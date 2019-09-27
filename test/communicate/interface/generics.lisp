;;;; test/communicate/interface/generics.lisp

(in-package #:raft-communicate-test)

(nst:def-test-group generics-tests ()
  (nst:def-test send-to-peer-is-generic-function (:equal t)
    (typep #'send-to-peer 'generic-function)))
