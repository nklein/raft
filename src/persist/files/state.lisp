;;; src/persist/files/state.lisp

(in-package #:raft-persist-files)

(defmethod store-state ((store persist-files) state)
  (let ((path (merge-pathnames #P"state.dat" (persist-files-pathname store))))
    (handler-case
        (with-output-to-backup-file (stream path)
          (write-sequence state stream))
      (error (err)
        (error 'store-error
               :store store
               :bytes state
               :reason "Failed to write data with backup file"
               :inner-error err))))
  (values))

(defmethod retrieve-state ((store persist-files))
  (let ((path (merge-pathnames #P"state.dat" (persist-files-pathname store))))
    (ignore-errors
      (with-input-from-backup-file (stream path)
        (let ((seq (make-array (list (file-length stream))
                               :element-type '(unsigned-byte 8)
                               :initial-element 0)))
          (read-sequence seq stream)
          (coerce seq '(vector (unsigned-byte 8))))))))
