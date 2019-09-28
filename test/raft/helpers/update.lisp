;;;; test/raft/update.lisp

(in-package #:raft-test)

(defun make-update-helper ()
  (make-hash-table :test 'eql))

(defun make-log-entry (cmd name value)
  (check-type cmd (member :+ :- :=))
  (check-type name keyword)
  (check-type value integer)
  (string-to-utf-8-bytes
   (with-output-to-string (out)
     (with-standard-io-syntax
       (write (list cmd name value))))))

(defmethod update ((updater hash-table) bytes)
  (check-type bytes (vector (unsigned-byte 8)))
  (with-input-from-string (in (utf-8-bytes-to-string bytes))
    (with-standard-io-syntax
      (destructuring-bind (cmd name value)
          (read in)
        (check-type name keyword)
        (ecase cmd
          (:+
           (check-type value integer)
           (incf (gethash name updater 0) value))
          (:-
           (check-type value integer)
           (decf (gethash name updater 0) value))
          (:=
           (check-type value integer)
           (setf (gethash name updater) value))))))
  (values))

(defun get-shared-state (updater name &optional default)
  (check-type updater hash-table)
  (check-type name keyword)
  (values (gethash name updater default)))
