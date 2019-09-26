;;;; test/persist/interface/store-error.lisp

(in-package #:raft-persist-test)

(nst:def-fixtures store-error-fixture ()
  (store (list :store))
  (state (coerce (vector 0 1 1 2 3 5 8) '(vector (unsigned-byte 8))))
  (reason "Reason")
  (inner-error (make-condition 'file-error
                               :pathname #P"/no/such/file"))
  )

(nst:def-test-group store-error-tests (store-error-fixture)
  (nst:def-test store-error-extends-error (:values (:equal t)
                                                   (:equal t))
    (subtypep 'store-error 'error))

  (nst:def-test store-error-has-slot-for-store (:true)
    (make-condition 'store-error
                    :store store))

  (nst:def-test store-error-has-reader-for-store (:equal store)
    (store-error-store (make-condition 'store-error
                                       :store store)))

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
                                       :bytes state)))

  (nst:def-test store-error-has-slot-for-reason (:true)
    (make-condition 'store-error
                    :store store
                    :bytes state
                    :reason reason))

  (nst:def-test store-error-has-reader-for-reason (:equal reason)
    (store-error-reason (make-condition 'store-error
                                        :store store
                                        :bytes state
                                        :reason reason)))

  (nst:def-test store-error-requires-reason-to-be-string (:err)
    (make-condition 'store-error
                    :store store
                    :bytes state
                    :reason (list :reason)))

  (nst:def-test store-error-has-slot-for-inner-error (:true)
    (make-condition 'store-error
                    :store store
                    :bytes state
                    :reason reason
                    :inner-error inner-error
                    ))

  (nst:def-test store-error-has-reader-for-inner-error (:equal inner-error)
    (store-error-inner-error (make-condition 'store-error
                                             :store store
                                             :bytes state
                                             :reason reason
                                             :inner-error inner-error)))

  (nst:def-test store-error-requires-inner-error-to-be-error (:err)
    (make-condition 'store-error
                    :store store
                    :bytes state
                    :reason reason
                    :inner-error "file not found"))
  )
