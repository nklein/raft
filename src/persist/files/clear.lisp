;;; src/persist/files/clear.lisp

(in-package #:raft-persist-files)

(defmethod clear ((store persist-files))
  (let ((state (merge-pathnames (state-name)
                                (persist-files-pathname store)))
        (log-entries (merge-pathnames (log-entry-wildcard)
                                      (persist-files-pathname store))))
    (delete-backup-file state)
    (mapcar #'delete-backup-file
            (directory log-entries :directories nil)))
  (values))
