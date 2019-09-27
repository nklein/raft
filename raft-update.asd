;;;; raft-update.asd

(asdf:defsystem #:raft-update
  :description "Defines the interface needed for the RAFT package
to act on the shared state."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190927"
  :license "UNLICENSE"
  :depends-on ()
  :in-order-to ((asdf:test-op (asdf:load-op :raft-update-test)))
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :raft-update-test :run-all-tests))
  :components
  ((:module "src/update/interface"
    :components ((:static-file "README.md")
                 (:file "package")
                 (:file "generics" :depends-on ("package"))))))
