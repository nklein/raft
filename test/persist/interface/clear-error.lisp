;;;; test/persist/interface/clear-error.lisp

(in-package #:raft-persist-test)

(nst:def-test-group clear-error-tests (persist-error-fixture)
  (nst:def-test clear-error-extends-store-error (:values (:equal t)
                                                               (:equal t))
    (subtypep 'clear-error 'persist-error))

  (nst:def-test clear-can-be-created (:true)
    (make-condition 'clear-error
                    :store store
                    :reason reason
                    :inner-error inner-error)))
