;;;; test/raft/election.lisp

(in-package #:raft-test)

(defmethod raft-id ((p peer))
  (raft-id (server p)))

(defun prepare-peers (n server-loop)
  (let ((peers (loop :for id :from 1 :to n
                  :for peer := (make-peer id)
                  :collecting peer)))
    (loop :for peer :in peers
       :do (setf (peers (server peer))
                 (mapcar #'raft-id (remove peer peers)))
       :do (start peer server-loop))
    peers))

(defun teardown-peers (peers)
  (loop :for peer :in peers
     :do (stop peer)))

(defun test-election-happens-fast (peer-count)
  (let ((election-complete (bt:make-semaphore :name "GROUP-ELECT SEMAPHORE"
                                              :count 0)))
    (flet ((server-loop (peer)
             (loop :while (with-peer-locked (peer)
                            (runningp peer))
                :do (process-all-messages peer)
                :do (when (with-peer-locked (peer)
                            (leaderp (server peer)))
                      (bt:signal-semaphore election-complete)))))
      (let ((peers (prepare-peers peer-count #'server-loop)))
        (unwind-protect
             (bt:wait-on-semaphore election-complete
                                   :timeout 1)
          (teardown-peers peers))))))

(nst:def-test-group raft-election-tests ()
  (nst:def-test group-elects-leader-quickly-for-three-peers (:true)
    (test-election-happens-fast 3))

  (nst:def-test group-elects-leader-quickly-for-single-peer (:true)
    (test-election-happens-fast 1)))
