;;;; test/persist/interface/store-log-entry-error.lisp

(in-package #:raft-persist-test)

(nst:def-fixtures store-log-entry-error-fixture ()
  (log1 (coerce (vector 0 1 2 3 4 5 6 7) '(vector (unsigned-byte 8)))))

(nst:def-test-group store-log-entry-error-tests (persist-error-fixture
                                                 store-error-fixture
                                                 store-log-entry-error-fixture)
  (nst:def-test store-log-entry-error-extends-store-error (:values (:equal t)
                                                                   (:equal t))
    (subtypep 'store-log-entry-error 'store-error))

  (nst:def-test store-log-entry-error-has-slot-for-index (:true)
    (make-condition 'store-log-entry-error
                    :store store
                    :bytes log1
                    :reason reason
                    :inner-error inner-error
                    :index 1))

  (nst:def-test store-log-entry-error-requires-index-to-be-positive (:err)
    (make-condition 'store-log-entry-error
                    :store store
                    :bytes log1
                    :reason reason
                    :inner-error inner-error
                    :index 0))

  (nst:def-test store-error-has-reader-for-index (:equal 1)
    (store-log-entry-error-index (make-condition 'store-log-entry-error
                                                 :store store
                                                 :bytes log1
                                                 :reason reason
                                                 :inner-error inner-error
                                                 :index 1))))
