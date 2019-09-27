;;; src/persist/files/state.lisp

(in-package #:raft-persist-files)

(defun state-name ()
  #P"state.dat")

(defmethod store-state ((store persist-files) bytes)
  (let ((path (merge-pathnames (state-name)
                               (persist-files-pathname store))))
    (handler-case
        (with-output-to-backup-file (stream path)
          (write-sequence bytes stream))
      (error (err)
        (error 'store-state-error
               :store store
               :bytes bytes
               :reason "Failed to write data with backup file"
               :inner-error err))))
  (values))

(defmethod retrieve-state ((store persist-files))
  (let ((path (merge-pathnames (state-name)
                               (persist-files-pathname store))))
    (values
     (ignore-errors
       (with-input-from-backup-file (stream path)
         (let ((bytes (make-array (list (file-length stream))
                                  :element-type '(unsigned-byte 8)
                                  :initial-element 0)))
           (read-sequence bytes stream)
           (coerce bytes '(vector (unsigned-byte 8)))))))))
