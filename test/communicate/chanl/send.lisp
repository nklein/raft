;;;; test/communicate/chanl/send.lisp

(in-package #:raft-communicate-chanl-test)

(nst:def-fixtures send-data ()
  (bytes (coerce (vector 0 1 1 2 3 5) '(vector (unsigned-byte 8)))))

(defclass peer-with-chanl ()
  ((chanl :reader chanl
          :initarg :chanl)))

(nst:def-test-group send-tests (communicate-chanl-data
                                send-data)
  (nst:def-test can-make-communicate-chanl-instance (:equalp bytes)
    (let* ((peer-chanl (make-instance 'chanl:channel))
           (peer (make-instance 'peer-with-chanl
                                :chanl peer-chanl))
           (task (bt:make-thread (lambda ()
                                   (send-to-peer chanl peer bytes))
                                 :name "SEND-TEST-SENDER"
                                 :initial-bindings `((chanl . ,chanl)
                                                     (bytes . ,bytes)))))
      (prog1
          (chanl:recv peer-chanl)
        (bt:join-thread task)))))
