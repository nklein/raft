;;; src/update/interface/generics.lisp

(in-package #:raft-update)

(defgeneric update (store bytes))
