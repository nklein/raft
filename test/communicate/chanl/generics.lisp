;;;; test/communicate/chanl/generics.lisp

(in-package #:raft-communicate-chanl-test)

(nst:def-test-group generics-tests ()
  (nst:def-test send-to-peer-is-generic-function (:equal t)
    (typep #'chanl 'generic-function)))
