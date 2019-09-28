;;; src/raft/construct.lisp

(in-package #:raft)

(defconstant +minimum-election-timeout+ 0.1
  "The minimum number of seconds allowed for an election timeout")

(deftype role-type () '(member :unassigned :candidate :leader :follower))

(defmacro with-raft-locked ((raft) &body body)
  `(bt:with-lock-held ((lock ,raft))
     ,@body))

(defclass raft-server ()
  ((id :reader raft-id
       :initarg :raft-id)
   (persist :reader %persist
            :initarg :persist)
   (update :reader %update
           :initarg :update)
   (communicate :reader %communicate
                :initarg :communicate)

   ;; persistent private state
   (current-term :accessor current-term
                 :initform 0)
   (voted-for :accessor voted-for
              :initform nil)
   (logs :accessor logs
         :initform (make-array 0 :adjustable t))

   ;; private transient state
   (lock :accessor lock)
   (role :accessor role
         :initform :unassigned
         :type role-type)
   (peers :accessor peers
          :initform nil)

   ;; private timeouts
   (election-timeout :reader election-timeout
                     :initarg :election-timeout)
   (election-expires :accessor election-expires)
   (broadcast-timeout :reader broadcast-timeout
                      :initarg :broadcast-timeout)
   (broadcast-expires :accessor broadcast-expires)))

(defmethod initialize-instance :after ((raft raft-server)
                                       &key &allow-other-keys)
  ;; prepare the lock
  (setf (lock raft) (bt:make-lock (format nil "RAFT ~A LOCK" (raft-id raft))))

  ;; start the timers to expire randomly within the next broadcast-timeout
  (let ((starting-at (now))
        (election-timeout (election-timeout raft))
        (broadcast-timeout (broadcast-timeout raft)))
    (setf (election-expires raft) (deadline (- (random broadcast-timeout)
                                               election-timeout)
                                            starting-at)
          (broadcast-expires raft) (deadline (- (random broadcast-timeout)
                                                broadcast-timeout)
                                             starting-at))))

(defun make-raft-server (id
                         &key
                           persist-instance
                           update-instance
                           communicate-instance
                           (election-timeout 10)
                           (broadcast-timeout 1))
  (assert id)
  (check-type persist-instance (not null))
  (check-type update-instance (not null))
  (check-type communicate-instance (not null))
  (check-type election-timeout real)
  (check-type broadcast-timeout real)
  (assert (<= +minimum-election-timeout+ election-timeout))
  (assert (<= (* 3 broadcast-timeout) election-timeout))
  (make-instance 'raft-server
                 :raft-id id
                 :persist persist-instance
                 :update update-instance
                 :communicate communicate-instance
                 :election-timeout election-timeout
                 :broadcast-timeout broadcast-timeout))
