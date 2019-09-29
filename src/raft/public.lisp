;;; src/raft/public.lisp

(in-package #:raft)

(defun process-timers (raft)
  (check-type raft raft-server)
  (let ((now (now)))
    (with-raft-locked (raft)
      (if (leaderp raft)
          (when (< (broadcast-expires raft) now)
            (append-entries raft now))
          (when (< (election-expires raft) now)
            (become-candidate raft now)))
      (seconds-until-next-timer raft now))))

(defun process-msg (raft peer-handle encoded-msg)
  (check-type raft raft-server)
  (check-type peer-handle (not null))
  (check-type encoded-msg (vector (unsigned-byte 8)))
  (multiple-value-bind (msg-type msg payload)
      (decode-message encoded-msg)
    (with-raft-locked (raft)
      (handle-message raft peer-handle msg-type msg payload))))
