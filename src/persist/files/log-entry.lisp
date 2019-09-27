;;; src/persist/files/log-entry.lisp

(in-package #:raft-persist-files)

(defun log-entry-name (index)
  (pathname (format nil "log-entry.~D" index)))

(defun log-entry-wildcard ()
  (pathname "log-entry.*"))

(defmethod store-log-entry ((store persist-files) index bytes)
  (let ((path (merge-pathnames (log-entry-name index)
                               (persist-files-pathname store))))
    (handler-case
        (with-output-to-backup-file (stream path)
          (write-sequence bytes stream))
      (error (err)
        (error 'store-log-entry-error
               :store store
               :index index
               :bytes state
               :reason "Failed to write data with backup file"
               :inner-error err))))
  (values))

(defmethod retrieve-log-entry ((store persist-files) index)
  (let ((path (merge-pathnames (log-entry-name index)
                               (persist-files-pathname store))))
    (values
     (ignore-errors
       (with-input-from-backup-file (stream path)
         (let ((seq (make-array (list (file-length stream))
                                :element-type '(unsigned-byte 8)
                                :initial-element 0)))
           (read-sequence seq stream)
           (coerce seq '(vector (unsigned-byte 8)))))))))
