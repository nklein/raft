;;; src/persist/interface/store-error.lisp

(in-package #:raft-persist)

(define-condition store-error (error)
  ((store :reader store-error-store
          :initarg :store)
   (bytes :reader store-error-bytes
          :initarg :bytes
          :type (vector (unsigned-byte 8)))
   (reason :reader store-error-reason
           :initarg :reason
           :type string)
   (inner-error :reader store-error-inner-error
                :initarg :inner-error
                :type error)))

(defun print-store-error (err stream)
  (check-type err store-error)
  (when (slot-boundp err 'store)
    (format stream " when writing to ~A" (store-error-store err)))
  (when (slot-boundp err 'bytes)
    (format stream " trying to write ~D bytes"
            (length (store-error-bytes err))))
  (when (slot-boundp err 'reason)
    (format stream " failed for ~S" (store-error-reason err)))
  (when (slot-boundp err 'inner-error)
    (format stream " caused by ~A" (store-error-inner-error err))))

(defmethod print-object ((err store-error) stream)
  (cond
    ((or *print-escape*
         *print-readably*)
     (call-next-method))
    (t
     (format stream "~A" (class-name (class-of err)))
     (print-store-error err stream))))
