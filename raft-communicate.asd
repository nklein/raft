;;;; raft-communicate.asd

(asdf:defsystem #:raft-communicate
  :description "Defines the interface needed for the RAFT package
to communicate with its peers."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ()
  :in-order-to ((asdf:test-op (asdf:load-op :raft-communicate-test)))
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :raft-communicate-test :run-all-tests))
  :components
  ((:module "src/communicate/interface"
    :components ((:static-file "README.md")
                 (:file "package")
                 (:file "generics" :depends-on ("package"))))))
