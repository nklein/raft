;;;; raft-communicate-chanl-test.asd

(asdf:defsystem #:raft-communicate-chanl-test
  :description "Tests for the RAFT-COMMUNICATE-CHANL package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ((:version #:raft-communicate-chanl "0.1.20190927")
               #:chanl
               #:bordeaux-threads
               #:nst)
  :components
  ((:module "test/communicate/chanl"
    :components ((:file "package")
                 (:file "generics" :depends-on ("package"))
                 (:file "construct" :depends-on ("package"))
                 (:file "send" :depends-on ("package"
                                            "construct"))
                 (:file "run" :depends-on ("package"))))))
