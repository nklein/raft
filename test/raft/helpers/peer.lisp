;;;; test/raft/peer.lisp

(in-package #:raft-test)

(defclass peer ()
  ((server :reader server
           :initarg :server)
   (inbox :reader inbox
          :initarg :inbox)))

(defun make-peer ()
  (let* ((persist (make-persist-helper))
         (update (make-update-helper))
         (communicate (make-communicate-helper))
         (server (make-raft-server :persist-instance persist
                                   :update-instance update
                                   :communicate-instance communicate))
         (queue (make-instance 'unbounded-fifo-queue))
         (inbox (make-instance 'synchronized-queue :queue queue)))
    (make-instance 'peer
                   :server server
                   :inbox inbox)))
