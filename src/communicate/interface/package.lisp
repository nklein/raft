;;; src/communicate/interface/package.lisp

(defpackage #:raft-communicate
  (:use #:cl)
  ;; exports from generics
  (:export #:send-to-peer))
