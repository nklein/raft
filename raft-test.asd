;;;; raft-test.asd

(asdf:defsystem #:raft-test
  :description "Tests for the RAFT package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190926"
  :license "UNLICENSE"
  :depends-on ((:version #:raft "0.1.20190926")
               #:nst)
  :components
  ((:module "test/raft"
    :components ((:file "package")
                 (:file "run" :depends-on ("package"))))))
