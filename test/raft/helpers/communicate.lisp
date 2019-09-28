;;;; test/raft/communicate.lisp

(in-package #:raft-test)

(let ((lock (bt:make-lock "MAKE-PEER LOCK"))
      (peers (make-hash-table :test 'eql)))

  (defun get-peer (id)
    (bt:with-lock-held (lock)
      (gethash id peers)))

  (defun (setf get-peer) (peer id)
    (bt:with-lock-held (lock)
      (setf (gethash id peers) peer))))

(defun make-communicate-helper (id)
  id)

(defmethod send-to-peer ((sender integer) peer-handle bytes)
  (let ((peer (get-peer peer-handle)))
    (enqueue (cons sender bytes) (inbox peer)))
  (bt:signal-semaphore (semaphore peer-handle)))
