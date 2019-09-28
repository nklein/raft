;;; src/raft/package.lisp

(defpackage #:raft
  (:use #:raft-persist
        #:raft-update
        #:raft-communicate
        #:trivial-utf-8
        #:cl)
  ;; from construct
  (:export #:+minimum-election-timeout+
           #:make-raft-server
           #:raft-id
           #:peers)
  ;; from public
  (:export #:leaderp
           #:process-timers
           #:process-msg))
