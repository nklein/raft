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
                                  (raft-id raft)
                                  index
                                  (or (log-msg-term log-msg)
                                      0)))
           (encoded-msg (encode-message :request-vote msg)))
      (send-to-peers raft encoded-msg)))
  (values))

(defun become-leader (raft now)
  (setf (role raft) :leader
        (broadcast-expires raft) now))

(defun calculate-votes-needed (peer-count)
  (values (ceiling peer-count 2)))

(defun become-candidate (raft now)
  (setf (role raft) :candidate
        (voted-for raft) (raft-id raft)
        (votes-needed raft) (calculate-votes-needed (length (peers raft))))
  (incf (current-term raft))
  (reset-election-timer raft now)
  (if (plusp (votes-needed raft))
      (request-vote raft)
      (become-leader raft now)))

(defun append-entries (raft now)
  ;; TODO: something
  (reset-broadcast-timer raft now))
