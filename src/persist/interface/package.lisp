;;; src/persist/interface/package.lisp

(defpackage #:raft-persist
  (:use #:cl)
  ;; exports from persist-error
  (:export #:persist-error
           #:persist-error-store
           #:persist-error-reason
           #:persist-error-inner-error)
  ;; exports from store-error
  (:export #:store-error
           #:store-error-bytes)
  ;; exports from store-state-error
  (:export #:store-state-error)
  ;; exports from store-log-entry-error
  (:export #:store-log-entry-error
           #:store-log-entry-error-index)
  ;; exports from clear-error
  (:export #:clear-error))
