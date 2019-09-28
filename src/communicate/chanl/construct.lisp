;;; src/communicate/chanl/construct.lisp

(in-package #:raft-communicate-chanl)

(defclass communicate-chanl ()
  ())

(defun make-communicate-chanl ()
  (make-instance 'communicate-chanl))
