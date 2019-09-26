;;; src/persist/interface/package.lisp

(defpackage #:raft-persist
  (:use #:cl)
  ;; exports from store-error
  (:export #:store-error
           #:store-error-store
           #:store-error-bytes
           #:store-error-reason
           #:store-error-inner-error)
  ;; exports from store-state-error
  (:export #:store-state-error))
