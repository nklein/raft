;;;; test/raft/construct.lisp

(in-package #:raft-test)

(nst:def-fixtures raft-server-data (:special ((:fixture raft-server-helpers)))
  (server (make-raft-server :persist-instance (make-persist-helper)
                            :update-instance (make-update-helper)
                            :communicate-instance (make-communicate-helper))))

(nst:def-test-group raft-constructor-tests (raft-server-helpers
                                            raft-server-data)
  (nst:def-test can-construct-raft-server (:true)
    server))
