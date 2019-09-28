;;;; test/raft/peer.lisp

(in-package #:raft-test)

(defclass peer ()
  ((id :reader id
       :initarg :id)
   (lock :reader lock
         :initarg :lock)
   (server :reader server
           :initarg :server)
   (inbox :reader inbox
          :initarg :inbox)
   (semaphore :reader semaphore
              :initarg :semaphore)
   (thread :accessor thread)
   (runningp :accessor runningp)))

(defmacro with-peer-locked ((peer) &body body)
  (let ((p (gensym "PEER")))
    `(let ((,p ,peer))
       (bt:with-lock-held ((lock ,p))
         ,@body))))

(let ((lock (bt:make-lock "MAKE-PEER LOCK"))
      (peers (make-hash-table :test 'eql)))

  (defun get-peer (id)
    (bt:with-lock-held (lock)
      (gethash id peers)))

  (defun (setf get-peer) (peer id)
    (bt:with-lock-held (lock)
      (setf (gethash id peers) peer))))

(defun make-peer ()
  (let* ((persist (make-persist-helper))
         (update (make-update-helper))
         (communicate (make-communicate-helper))
         (id communicate)
         (lock (bt:make-lock (format nil "PEER ~A LOCK" id)))
         (server (make-raft-server :persist-instance persist
                                   :update-instance update
                                   :communicate-instance communicate))
         (queue (make-instance 'unbounded-fifo-queue))
         (inbox (make-instance 'synchronized-queue :queue queue))
         (semaphore (bt:make-semaphore :name (format nil "PEER ~A SEMAPHORE"
                                                     id)))
         (peer (make-instance 'peer
                              :id id
                              :lock lock
                              :server server
                              :inbox inbox
                              :semaphore semaphore)))
    (setf (get-peer id) peer)
    peer))

(defun start (peer server-loop)
  (with-peer-locked (peer)
    (setf (thread peer) (bt:make-thread (lambda ()
                                          (with-peer-locked (peer)
                                            (setf (runningp peer) t))
                                          (funcall server-loop peer))
                                        :name (format nil "PEER ~A THREAD"
                                                      (id peer))))))

(defun stop (peer)
  (when (runningp peer)
    (with-peer-locked (peer)
      (setf (runningp peer) nil))
    (bt:join-thread (with-peer-locked (peer)
                      (thread peer)))))

(defun process-msg (peer msg)
  (declare (ignore peer msg)))

(defun process-all-messages (peer)
  (loop :while (bt:wait-on-semaphore (semaphore peer) :timeout 0.5)
     :for msg := (dequeue (inbox peer))
     :do (process-msg peer msg))
  (values))

(defun leaderp (peer)
  (declare (ignore peer))
  nil)
