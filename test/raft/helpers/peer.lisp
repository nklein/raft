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

(defun make-peer (id)
  (let* ((persist (make-persist-helper))
         (update (make-update-helper))
         (communicate (make-communicate-helper id))
         (lock (bt:make-lock (format nil "PEER ~A LOCK" id)))
         (election-timeout +minimum-election-timeout+)
         (broadcast-timeout (/ election-timeout 5))
         (server (make-raft-server id
                                   :persist-instance persist
                                   :update-instance update
                                   :communicate-instance communicate
                                   :election-timeout election-timeout
                                   :broadcast-timeout broadcast-timeout))
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
                                                      (raft-id
                                                       (server peer)))))))

(defun stop (peer)
  (when (runningp peer)
    (with-peer-locked (peer)
      (setf (runningp peer) nil))
    (bt:join-thread (with-peer-locked (peer)
                      (thread peer)))))

(defun process-all-messages (peer)
  (loop
     :with semaphore := (with-peer-locked (peer)
                          (semaphore peer))
     :for timeout := (with-peer-locked (peer)
                       (process-timers (server peer)))
     :while (bt:wait-on-semaphore semaphore :timeout timeout)
     :for (from . msg) := (with-peer-locked (peer)
                            (dequeue (inbox peer)))
     :do (process-msg (with-peer-locked (peer)
                        (server peer))
                      from
                      msg))
  (values))
