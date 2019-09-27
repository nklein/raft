;;;; test/persist/files/creation.lisp

(in-package #:raft-persist-files-test)

(nst:def-fixtures persist-files-instance ()
  (store (make-persist-files #P"/tmp/")))

(nst:def-test-group persist-files-creation-tests (persist-files-instance)
  (nst:def-test can-create-instance (:true)
    store)

  (nst:def-test can-create-instance-requires-directory (:err)
    (make-persist-files #P"/tmp"))

  (nst:def-test can-create-instance-allows-pathname-designator (:true)
    (make-persist-files "/tmp/")))
