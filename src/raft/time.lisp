;;; src/raft/time.lisp

(in-package #:raft)

(declaim (inline now))
(defun now ()
  (get-internal-real-time))

(declaim (inline deadline))
(defun deadline (expire-in-seconds &optional (starting-from (now)))
  (+ starting-from
     (* expire-in-seconds internal-time-units-per-second)))
