;;;; test/raft/communicate.lisp

(in-package #:raft-test)

(defun make-communicate-helper ()
  :comms)

(defmethod send-to-peer ((sender keyword) peer-handle bytes)
  (enqueue bytes (inbox peer-handle)))
