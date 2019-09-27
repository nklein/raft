;;; src/persist/files/creation.lisp

(in-package #:raft-persist-files)

(defclass persist-files ()
  ((pathname :initarg :pathname
             :reader persist-files-pathname)))

(defun make-persist-files (pathname)
  (let ((pathname (pathname pathname)))
    (assert (null (pathname-name pathname)))
    (make-instance 'persist-files :pathname pathname)))
