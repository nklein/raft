;;; src/communicate/interface/generics.lisp

(in-package #:raft-communicate)

(defgeneric send-to-peer (sender peer-handle bytes))
