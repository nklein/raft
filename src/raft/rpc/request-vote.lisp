;;; src/raft/rpc/request-vote.lisp

(in-package #:raft)

(define-assoc-reader request-vote-term (:term))
(define-assoc-reader request-vote-candidate-id (:candidate-id))
(define-assoc-reader request-vote-last-log-index (:last-log-index))
(define-assoc-reader request-vote-last-log-term (:last-log-term))
(define-assoc-reader request-vote-vote-granted (:vote-granted))

(defun request-vote-msg (term candidate-id last-log-index last-log-term)
  (check-type term integer)
  (check-type last-log-index integer)
  (check-type last-log-term integer)
  (list (make-request-vote-term term)
        (make-request-vote-candidate-id candidate-id)
        (make-request-vote-last-log-index last-log-index)
        (make-request-vote-last-log-term last-log-term)))

(defun request-vote-response (term vote-granted)
  (check-type term integer)
  (check-type vote-granted boolean)
  (list (make-request-vote-term term)
        (make-request-vote-vote-granted vote-granted)))
