;;;; test/update/interface/generics.lisp

(in-package #:raft-update-test)

(nst:def-test-group generics-tests ()
  (nst:def-test update-is-generic-function (:equal t)
    (typep #'update 'generic-function)))
