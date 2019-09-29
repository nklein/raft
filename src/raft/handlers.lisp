;;; src/raft/handlers.lisp

(in-package #:raft)

(defgeneric handle-message (raft peer-handle msg-type msg payload))

(defun log-at-least-as-long-p (raft other-log-term other-log-index)
  (multiple-value-bind (our-log-index our-log-msg) (last-log-msg raft)
    (let ((our-log-term (or (log-msg-term our-log-msg)
                            0)))
      (or (< our-log-term other-log-term)
          (and (= our-log-term other-log-term)
               (< our-log-index other-log-index))))))

(defmethod handle-message ((raft raft-server)
                           peer-handle
                           (msg-type (eql :request-vote))
                           msg
                           payload)
  (declare (ignore payload))
  (let* ((term (request-vote-term msg))
         (candidate-id (request-vote-candidate-id msg))
         (last-log-term (request-vote-last-log-term msg))
         (last-log-index (request-vote-last-log-index msg))

         (vote-granted (with-raft-locked (raft)
                         (and (< (current-term raft) term)
                              (log-at-least-as-long-p raft
                                                      last-log-term
                                                      last-log-index)))))
    (send-to-peer (%communicate raft)
                  peer-handle
                  (encode-message :request-vote-response
                                  (request-vote-response term vote-granted)))
    (when vote-granted
      (setf (voted-for raft) candidate-id
            (current-term raft) term))))

(defmethod handle-message ((raft raft-server)
                           peer-handle
                           (msg-type (eql :request-vote-response))
                           msg
                           payload)
  ;; NOTE: if a peer reply is duplicated, then we are going to
  ;; double-count their vote. Need to deal with this at some point.
  (declare (ignore peer-handle payload))
  (let ((term (request-vote-term msg))
        (vote-granted (request-vote-vote-granted msg)))
    (when (and vote-granted
               (= term (current-term raft))
               (zerop (decf (votes-needed raft))))
      (become-leader raft (now)))))
