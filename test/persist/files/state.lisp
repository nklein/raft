;;;; test/persist/files/state.lisp

(in-package #:raft-persist-files-test)

(nst:def-fixtures state-data ()
  (state1 (coerce (vector 0 1 1 2 3 5 8) '(vector (unsigned-byte 8))))
  (state2 (coerce (vector 1 2 4 8) '(vector (unsigned-byte 8)))))

(nst:def-test-group persist-files-state-tests (persist-files-instance
                                               state-data)
  (nst:def-test can-store-state (:values)
    (store-state store state1))

  (nst:def-test can-retrieve-state (:equalp state1)
    (progn
      (store-state store state1)
      (retrieve-state store)))

  (nst:def-test can-overwrite-state (:equalp state2)
    (progn
      (store-state store state1)
      (store-state store state2)
      (retrieve-state store))))
