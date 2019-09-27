;;;; test/persist/files/log-entry.lisp

(in-package #:raft-persist-files-test)

(nst:def-fixtures log-entry-data ()
  (log1 (coerce (vector 0 1 1 2 3 5 8 13) '(vector (unsigned-byte 8))))
  (log2 (coerce (vector 1 2 4 8 16) '(vector (unsigned-byte 8)))))

(nst:def-test-group persist-files-log-entry-tests (persist-files-instance
                                                   log-entry-data)
  (nst:def-test can-store-log-entry (:values)
    (store-log-entry store 1 log1))

  (nst:def-test can-retrieve-log-entry (:equalp log1)
    (progn
      (store-log-entry store 1 log1)
      (retrieve-log-entry store 1)))

  (nst:def-test can-overwrite-log-entry (:equalp log2)
    (progn
      (store-log-entry store 1 log1)
      (store-log-entry store 1 log2)
      (retrieve-log-entry store 1)))

  (nst:def-test can-save-multiple-log-entry (:values (:equalp log1)
                                                     (:equalp log2))
    (progn
      (store-log-entry store 1 log1)
      (store-log-entry store 2 log2)
      (values (retrieve-log-entry store 1)
              (retrieve-log-entry store 2)))))
