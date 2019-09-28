;;; src/raft/public.lisp

(in-package #:raft)

(defun leaderp (raft)
  (with-raft-locked (raft)
    (eql (role raft) :leader)))

(defun process-timers (raft)
  (check-type raft raft-server)
  (let ((now (now)))
    (when (< (election-expires raft) now)
      (with-raft-locked (raft)
        (request-vote raft)))
    (when (and (leaderp raft)
               (< (broadcast-expires raft) now))
      (with-raft-locked (raft)
        (append-entries raft)))))

(defun process-msg (raft peer-handle encoded-msg)
  (check-type raft raft-server)
  (check-type peer-handle (not null))
  (check-type encoded-msg (vector (unsigned-byte 8)))
  (multiple-value-bind (msg-type msg payload)
      (decode-message encoded-msg)
    (with-raft-locked (raft)
      (handle-message raft peer-handle msg-type msg payload))))
