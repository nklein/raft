;;;; raft-test.asd

(asdf:defsystem #:raft-test
  :description "Tests for the RAFT package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ((:version #:raft "0.1.20190927")
               #:bordeaux-threads
               #:jpl-queues
               #:trivial-utf-8
               #:nst)
  :components
  ((:module "test/raft"
    :components ((:file "package")
                 (:module "helpers"
                  :components ((:file "persist")
                               (:file "update")
                               (:file "communicate")
                               (:file "peer" :depends-on ("persist"
                                                          "update"
                                                          "communicate")))
                  :depends-on ("package"))
                 (:file "construct" :depends-on ("package"
                                                 "helpers"))
                 (:file "run" :depends-on ("package"))))))
