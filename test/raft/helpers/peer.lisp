;;;; test/raft/peer.lisp

(in-package #:raft-test)

(defclass peer ()
  ((server :reader server
           :initarg :server)
   (inbox :reader inbox
          :initarg :inbox)))

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
         (server (make-raft-server :persist-instance persist
                                   :update-instance update
                                   :communicate-instance communicate))
         (queue (make-instance 'unbounded-fifo-queue))
         (inbox (make-instance 'synchronized-queue :queue queue))
         (peer (make-instance 'peer
                              :server server
                              :inbox inbox)))
    (prog1
        peer
      (setf (get-peer communicate) peer))))
