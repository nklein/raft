;;; src/persist/interface/store-log-entry-error.lisp

(in-package #:raft-persist)

(define-condition store-log-entry-error (store-error)
  ((index :reader store-log-entry-error-index
          :initarg :index
          :type (integer 0))))

(defmethod print-object ((err store-log-entry-error) stream)
  (cond
    ((or *print-escape*
         *print-readably*)
     (call-next-method))
    (t
     (format stream "~A" (class-name (class-of err)))
     (when (slot-boundp err 'index)
       (format stream " on log entry ~D" (store-log-entry-error-index err)))
     (print-store-error err stream))))
