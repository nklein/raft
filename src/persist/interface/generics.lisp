;;; src/persist/interface/generics.lisp

(in-package #:raft-persist)

(defgeneric store-state (store bytes))

(defgeneric retrieve-state (store))

(defgeneric store-log-entry (store index bytes))

(defgeneric retrieve-log-entry (store index))

(defgeneric clear (store))
