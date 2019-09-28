;;;; raft-communicate-chanl.asd

(asdf:defsystem #:raft-communicate-chanl
  :description "Defines the interface needed for the RAFT package
to communicate with its peers."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on (#:raft-communicate
               #:chanl)
  :in-order-to ((asdf:test-op (asdf:load-op :raft-communicate-chanl-test)))
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :raft-communicate-chanl-test :run-all-tests))
  :components
  ((:module "src/communicate/chanl"
    :components ((:static-file "README.md")
                 (:file "package")
                 (:file "generics" :depends-on ("package"))
                 (:file "construct" :depends-on ("package"))
                 (:file "send" :depends-on ("package"
                                            "construct"))))))
