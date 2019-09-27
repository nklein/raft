;;;; test/persist/files/clear.lisp

(in-package #:raft-persist-files-test)

(nst:def-test-group persist-files-clear-tests (persist-files-instance
                                               state-data
                                               log-entry-data)
  (nst:def-test clear-clears-state (:equal nil)
    (progn
      (store-state store state1)
      (clear store)
      (retrieve-state store)))

  (nst:def-test clear-clears-log-entry (:values (:equal nil)
                                                (:equal nil))
    (progn
      (store-log-entry store 1 log1)
      (store-log-entry store 2 log2)
      (clear store)
      (values (retrieve-log-entry store 1)
              (retrieve-log-entry store 2)))))
