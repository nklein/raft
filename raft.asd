;;;; raft.asd

(asdf:defsystem #:raft
  :description "Implements the Raft consensus protocol.

For more details on the RAFT algorithm, see: https://raft.github.io/"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ((:version #:raft-persist "0.1.20190926")
               (:version #:raft-update "0.1.20190927")
               (:version #:raft-communicate "0.1.20190927")
               #:bordeaux-threads
               #:trivial-utf-8)
  :in-order-to ((asdf:test-op (asdf:load-op :raft-test)))
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :raft-test :run-all-tests))
  :components
  ((:static-file "README.md")
   (:static-file "UNLICENSE.txt")
   (:module "src/raft"
    :components ((:file "package")
                 (:file "time" :depends-on ("package"))
                 (:file "construct" :depends-on ("package"
                                                 "time"))
                 (:file "msg" :depends-on ("package"
                                           "construct"))
                 (:module "rpc"
                  :components ((:file "request-vote"))
                  :depends-on ("package"
                               "msg"))
                 (:file "timers" :depends-on ("package"
                                              "construct"
                                              "rpc"))
                 (:file "handlers" :depends-on ("package"
                                                "construct"
                                                "rpc"
                                                "timers"))
                 (:file "public" :depends-on ("package"
                                              "time"
                                              "construct"
                                              "msg"
                                              "handlers"
                                              "timers"))))))
