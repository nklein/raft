;;; src/raft/handlers.lisp

(in-package #:raft)

(defgeneric handle-message (raft peer-handle msg-type msg payload))

(defmethod handle-message ((raft raft-server)
                           peer-handle
                           (msg-type (eql :request-vote))
                           msg
                           payload)
  (declare (ignore raft peer-handle msg-type msg payload))
  (error "NOT IMPLEMENTED"))

(defmethod handle-message ((raft raft-server)
                           peer-handle
                           (msg-type (eql :request-vote-response))
                           msg
                           payload)
  (declare (ignore raft peer-handle msg-type msg payload))
  (error "NOT IMPLEMENTED"))
