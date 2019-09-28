;;;; test/raft/election.lisp

(in-package #:raft-test)

(defun (setf peers) (peers server)
  (declare (ignore peers server))
  ;; TODO: replace with real method in RAFT package
  )

(defun prepare-peers (n server-loop)
  (let ((peers (loop :for id :from 1 :to n
                  :for peer := (make-peer id)
                  :collecting peer)))
    (loop :for peer :in peers
       :do (setf (peers (server peer)) (remove peer peers))
       :do (start peer server-loop))
    peers))

(defun teardown-peers (peers)
  (loop :for peer :in peers
     :do (stop peer)))

(nst:def-test-group raft-election-tests ()
  (nst:def-test group-elects-leader-quickly (:perf :sec 1)
    (let ((election-complete (bt:make-semaphore :name "GROUP-ELECT SEMAPHORE"
                                                :count 0)))
      (flet ((server-loop (peer)
               (loop :while (with-peer-locked (peer)
                              (runningp peer))
                  :do (process-all-messages peer)
                  :when (leaderp (server peer))
                  :do (bt:signal-semaphore election-complete))))
        (let ((peers (prepare-peers 5 #'server-loop)))
          (unwind-protect
               (bt:wait-on-semaphore election-complete
                                     :timeout 2)
            (teardown-peers peers)))))))
