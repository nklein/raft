;;;; test/persist/interface/generics.lisp

(in-package #:raft-persist-test)

(nst:def-test-group generics-tests ()
  (nst:def-test store-state-is-generic-function (:equal t)
    (typep #'store-state 'generic-function))

  (nst:def-test retrieve-state-is-generic-function (:equal t)
    (typep #'retrieve-state 'generic-function))

  (nst:def-test store-log-entry-is-generic-function (:equal t)
    (typep #'store-log-entry 'generic-function))

  (nst:def-test retrieve-log-entry-is-generic-function (:equal t)
    (typep #'retrieve-log-entry 'generic-function))

  (nst:def-test clear-is-generic-function (:equal t)
    (typep #'clear 'generic-function)))
