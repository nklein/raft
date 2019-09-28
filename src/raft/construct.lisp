;;; src/raft/construct.lisp

(in-package #:raft)

(defclass raft-server ()
  ((persist :reader %persist
            :initarg :persist)
   (update :reader %update
           :initarg :update)
   (communicate :reader %communicate
                :initarg :communicate)))

(defun make-raft-server (&key
                           persist-instance
                           update-instance
                           communicate-instance)
  (check-type persist-instance (not null))
  (check-type update-instance (not null))
  (check-type communicate-instance (not null))
  (make-instance 'raft-server
                 :persist persist-instance
                 :update update-instance
                 :communicate communicate-instance))
