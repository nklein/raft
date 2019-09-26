;;; src/persist/interface/store-state-error.lisp

(in-package #:raft-persist)

(define-condition store-state-error (store-error)
  ())
