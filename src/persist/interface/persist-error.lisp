;;; src/persist/interface/persist-error.lisp

(in-package #:raft-persist)

(define-condition persist-error (error)
  ((store :reader persist-error-store
          :initarg :store)
   (reason :reader persist-error-reason
           :initarg :reason
           :type string)
   (inner-error :reader persist-error-inner-error
                :initarg :inner-error
                :type error)))

(defun print-persist-error (err stream)
  (check-type err persist-error)
  (when (slot-boundp err 'store)
    (format stream " when writing to ~A" (persist-error-store err)))
  (when (slot-boundp err 'reason)
    (format stream " failed for ~S" (persist-error-reason err)))
  (when (slot-boundp err 'inner-error)
    (format stream " caused by ~A" (persist-error-inner-error err))))

(defmethod print-object ((err persist-error) stream)
  (cond
    ((or *print-escape*
         *print-readably*)
     (call-next-method))
    (t
     (format stream "~A" (class-name (class-of err)))
     (print-persist-error err stream))))
