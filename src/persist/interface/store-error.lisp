;;; src/persist/interface/store-error.lisp

(in-package #:raft-persist)

(define-condition store-error (persist-error)
  ((bytes :reader store-error-bytes
          :initarg :bytes
          :type (vector (unsigned-byte 8)))))

(defun print-store-error (err stream)
  (check-type err store-error)
  (when (slot-boundp err 'bytes)
    (format stream " trying to write ~D bytes"
            (length (store-error-bytes err))))
  (print-persist-error err stream))

(defmethod print-object ((err store-error) stream)
  (cond
    ((or *print-escape*
         *print-readably*)
     (call-next-method))
    (t
     (format stream "~A" (class-name (class-of err)))
     (print-store-error err stream))))
