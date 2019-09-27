;;;; raft-communicate-test.asd

(asdf:defsystem #:raft-communicate-test
  :description "Tests for the RAFT-COMMUNICATE package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ((:version #:raft-communicate "0.1.20190927")
               #:nst)
  :components
  ((:module "test/communicate/interface"
    :components ((:file "package")
                 (:file "generics" :depends-on ("package"))
                 (:file "run" :depends-on ("package"))))))
