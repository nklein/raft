;;;; raft-persist.asd

(asdf:defsystem #:raft-persist
  :description "Defines the interface needed for the RAFT package
to store its persistent state."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190929"
  :license "UNLICENSE"
  :depends-on (#:interface)
  :in-order-to ((asdf:test-op (asdf:load-op :raft-persist-test)))
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :raft-persist-test :run-all-tests))
  :components
  ((:module "src/persist/interface"
    :components ((:static-file "README.md")
                 (:file "package")
                 (:file "store-error" :depends-on ("package"))
                 (:file "store-state-error" :depends-on ("package"
                                                         "store-error"))
                 (:file "store-log-entry-error"
                        :depends-on ("package"
                                     "store-error"))))))
