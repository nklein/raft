;;; src/communicate/chanl/package.lisp

(defpackage #:raft-communicate-chanl
  (:use #:raft-communicate #:cl)
  ;; from raft-communicate
  (:export #:send-to-peer)
  ;; from generics
  (:export #:chanl)
  ;; from construct
  (:export #:make-communicate-chanl))
