;;; src/persist/interface/clear-error.lisp

(in-package #:raft-persist)

(define-condition clear-error (persist-error)
  ())
