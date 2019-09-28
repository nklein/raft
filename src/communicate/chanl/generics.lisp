;;; src/communicate/chanl/generics.lisp

(in-package #:raft-communicate-chanl)

(defgeneric chanl (peer-handle)
  (:documentation "Return the CHANL instance used to send a message to the peer with the given PEER-HANDLE."))
