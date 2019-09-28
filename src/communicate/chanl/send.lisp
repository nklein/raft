;;; src/communicate/chanl/send.lisp

(in-package #:raft-communicate-chanl)

(defmethod send-to-peer ((sender communicate-chanl) peer-handle bytes)
  (chanl:send (chanl peer-handle) bytes))
