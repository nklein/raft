;;;; test/persist/interface/store-error.lisp

(in-package #:raft-persist-test)

(nst:def-fixtures store-error-fixture ()
  (state (coerce (vector 0 1 1 2 3 5 8) '(vector (unsigned-byte 8)))))

(nst:def-test-group store-error-tests (persist-error-fixture
                                       store-error-fixture)
  (nst:def-test store-error-extends-error (:values (:equal t)
                                                   (:equal t))
    (subtypep 'store-error 'persist-error))

  (nst:def-test store-error-has-slot-for-bytes (:true)
    (make-condition 'store-error
                    :store store
                    :bytes state))

  (nst:def-test store-error-requires-bytes-to-be-vector-of-byte (:err)
    (make-condition 'store-error
                    :store store
                    :bytes (coerce (vector 0 1 2) '(vector (integer 0)))))

  (nst:def-test store-error-has-reader-for-bytes (:equal state)
    (store-error-bytes (make-condition 'store-error
                                       :store store
                                       :bytes state))))
