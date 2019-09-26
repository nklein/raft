;;;; raft-persist-test.asd

(asdf:defsystem #:raft-persist-test
  :description "Tests for the RAFT-PERSIST package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190926"
  :license "UNLICENSE"
  :depends-on ((:version #:raft-persist "0.1.20190926")
               #:nst)
  :components
  ((:module "test/persist/interface"
    :components ((:file "package")
                 (:file "persist-error" :depends-on ("package"))
                 (:file "store-error" :depends-on ("package"
                                                   "persist-error"))
                 (:file "store-state-error" :depends-on ("package"
                                                         "persist-error"
                                                         "store-error"))
                 (:file "store-log-entry-error" :depends-on ("package"
                                                             "persist-error"
                                                             "store-error"))
                 (:file "clear-error" :depends-on ("package"
                                                   "persist-error"))
                 (:file "run" :depends-on ("package"))))))
