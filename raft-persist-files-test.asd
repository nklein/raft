;;;; raft-persist-files-test.asd

(asdf:defsystem #:raft-persist-files-test
  :description "Tests for the RAFT-PERSIST-FILES package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190926"
  :license "UNLICENSE"
  :depends-on ((:version #:raft-persist-files "0.1.20190926")
               #:nst)
  :components
  ((:module "test/persist/files"
    :components ((:file "package")
                 (:file "creation" :depends-on ("package"))
                 (:file "state" :depends-on ("package"
                                             "creation"))
                 (:file "log-entry" :depends-on ("package"
                                                 "creation"))
                 (:file "clear" :depends-on ("package"
                                             "creation"
                                             "state"
                                             "log-entry"))
                 (:file "run" :depends-on ("package"))))))
