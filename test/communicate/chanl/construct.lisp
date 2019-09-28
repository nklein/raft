;;;; test/communicate/chanl/construct.lisp

(in-package #:raft-communicate-chanl-test)

(nst:def-fixtures communicate-chanl-data ()
  (chanl (make-communicate-chanl)))

(nst:def-test-group construct-tests (communicate-chanl-data)
  (nst:def-test can-make-communicate-chanl-instance (:true)
    chanl))
