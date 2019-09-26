;;;; test/persist/interface/persist-error.lisp

(in-package #:raft-persist-test)

(nst:def-fixtures persist-error-fixture ()
  (store (list :store))
  (reason "Reason")
  (inner-error (make-condition 'file-error
                               :pathname #P"/no/such/file")))

(nst:def-test-group persist-error-tests (persist-error-fixture)
  (nst:def-test persist-error-extends-error (:values (:equal t)
                                                   (:equal t))
    (subtypep 'persist-error 'error))

  (nst:def-test persist-error-has-slot-for-store (:true)
    (make-condition 'persist-error
                    :store store))

  (nst:def-test persist-error-has-reader-for-store (:equal store)
    (persist-error-store (make-condition 'persist-error
                                       :store store)))

  (nst:def-test persist-error-has-slot-for-reason (:true)
    (make-condition 'persist-error
                    :store store
                    :reason reason))

  (nst:def-test persist-error-has-reader-for-reason (:equal reason)
    (persist-error-reason (make-condition 'persist-error
                                        :store store
                                        :reason reason)))

  (nst:def-test persist-error-requires-reason-to-be-string (:err)
    (make-condition 'persist-error
                    :store store
                    :reason (list :reason)))

  (nst:def-test persist-error-has-slot-for-inner-error (:true)
    (make-condition 'persist-error
                    :store store
                    :reason reason
                    :inner-error inner-error))

  (nst:def-test persist-error-has-reader-for-inner-error (:equal inner-error)
    (persist-error-inner-error (make-condition 'persist-error
                                             :store store
                                             :reason reason
                                             :inner-error inner-error)))

  (nst:def-test persist-error-requires-inner-error-to-be-error (:err)
    (make-condition 'persist-error
                    :store store
                    :reason reason
                    :inner-error "file not found")))
