;;;; raft.asd

(asdf:defsystem #:raft
  :description "Implements the Raft consensus protocol.

For more details on the RAFT algorithm, see: https://raft.github.io/"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190926"
  :license "UNLICENSE"
  :depends-on ()
  :in-order-to ((asdf:test-op (asdf:load-op :raft-test)))
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :raft-test :run-all-tests))
  :components
  ((:static-file "README.md")
   (:static-file "UNLICENSE.txt")
   (:module "src/raft"
    :components ((:file "package")))))
