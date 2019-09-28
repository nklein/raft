;;;; test/raft/communicate.lisp

(in-package #:raft-test)

(let ((lock (bt:make-lock "MAKE-COMMUNICATE-HELPER LOCK"))
      (helper-number 0))
  (defun make-communicate-helper ()
    (bt:with-lock-held (lock)
      (incf helper-number))))

(defmethod send-to-peer ((sender integer) peer-handle bytes)
  (enqueue (cons sender bytes) (inbox peer-handle))
  (bt:signal-semaphore (semaphore peer-handle)))
