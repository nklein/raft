;;;; test/raft/persist.lisp

(in-package #:raft-test)

(defun make-persist-helper ()
  (make-hash-table :test 'eql))

(defmethod store-state ((store hash-table) bytes)
  (setf (gethash 0 store) bytes)
  (values))

(defmethod retrieve-state ((store hash-table))
  (values (gethash 0 store)))

(defmethod store-log-entry ((store hash-table) index bytes)
  (setf (gethash index store) bytes)
  (values))

(defmethod retrieve-log-entry ((store hash-table) index)
  (values (gethash index store)))

(defmethod clear ((store hash-table))
  (clrhash store))
