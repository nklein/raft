;;; src/raft/public.lisp

(in-package #:raft)

(defmacro define-role-predicate (name (tag))
  `(defun ,name (raft)
     (with-raft-locked (raft)
       (eql (role raft) ,tag))))

(define-role-predicate leaderp (:leader))
(define-role-predicate followerp (:follower))
(define-role-predicate candidatep (:candidate))

(defun process-timers (raft)
  (check-type raft raft-server)
  (let ((now (now)))
    (when (and (not (leaderp raft))
               (< (election-expires raft) now))
      (with-raft-locked (raft)
        (become-candidate raft now)))
    (when (and (leaderp raft)
               (< (broadcast-expires raft) now))
      (with-raft-locked (raft)
        (append-entries raft now)))
    (seconds-until-next-timer raft now)))

(defun process-msg (raft peer-handle encoded-msg)
  (check-type raft raft-server)
  (check-type peer-handle (not null))
  (check-type encoded-msg (vector (unsigned-byte 8)))
  (multiple-value-bind (msg-type msg payload)
      (decode-message encoded-msg)
    (with-raft-locked (raft)
      (handle-message raft peer-handle msg-type msg payload))))
