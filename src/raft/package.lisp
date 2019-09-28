;;; src/raft/package.lisp

(defpackage #:raft
  (:use #:raft-persist #:raft-update #:raft-communicate #:cl)
  ;; from construct
  (:export #:make-raft-server))
