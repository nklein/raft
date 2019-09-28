;;; src/raft/timers.lisp

(in-package #:raft)

(define-assoc-reader log-msg-term (:term))
(define-assoc-reader log-msg-command (:command))

(defun last-log-msg (raft)
  (let* ((logs (logs raft))
         (index (array-dimension logs 0)))
    (values index
            (when (plusp index)
              (aref logs (1- index))))))

(defun log-msg (term command)
  (list (make-log-msg-term term)
        (make-log-msg-command command)))

(defun send-to-peers (raft encoded-msg)
  (let ((sender (%communicate raft)))
    (dolist (peer-handle (peers raft))
      (send-to-peer sender peer-handle encoded-msg))))

(defun request-vote (raft)
  (multiple-value-bind (index log-msg) (last-log-msg raft)
    (let* ((msg (request-vote-msg (current-term raft)
                                  (id raft)
                                  (or index 0)
                                  (or (log-msg-term log-msg)
                                      0)))
           (encoded-msg (encode-message :request-vote msg)))
      (send-to-peers raft encoded-msg)))
  (values))

(defun append-entries (raft)
  (declare (ignore raft))
  ;; TODO: something
  )
