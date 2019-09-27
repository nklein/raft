;;;; raft-update-test.asd

(asdf:defsystem #:raft-update-test
  :description "Tests for the RAFT-UPDATE package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ((:version #:raft-update "0.1.20190927")
               #:nst)
  :components
  ((:module "test/update/interface"
    :components ((:file "package")
                 (:file "generics" :depends-on ("package"))
                 (:file "run" :depends-on ("package"))))))
