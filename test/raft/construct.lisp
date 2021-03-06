;;;; test/raft/construct.lisp

(in-package #:raft-test)

(nst:def-fixtures raft-server-data ()
  (server (make-raft-server 1
                            :persist-instance (make-persist-helper)
                            :update-instance (make-update-helper)
                            :communicate-instance (make-communicate-helper 1))))

(nst:def-test-group raft-constructor-tests (raft-server-data)
  (nst:def-test can-construct-raft-server (:true)
    server))
