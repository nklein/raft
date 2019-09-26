;;;; test/persist/interface/store-state-error.lisp

(in-package #:raft-persist-test)

(nst:def-test-group store-state-error-tests (store-error-fixture)
  (nst:def-test store-state-error-extends-error (:values (:equal t)
                                                         (:equal t))
    (subtypep 'store-state-error 'store-error))

  (nst:def-test store-error-can-be-created (:true)
    (make-condition 'store-state-error
                    :store store
                    :bytes state
                    :reason reason
                    :inner-error inner-error)))
