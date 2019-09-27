;;; src/persist/files/backup-utils.lisp

(in-package #:raft-persist-files)

(defun real-name (pathname)
  (merge-pathnames pathname #P".dat"))

(defun backup-name (pathname)
  (merge-pathnames (format nil ".~A-bk"
                           (pathname-type pathname))
                   pathname))

(defmacro with-output-to-backup-file ((stream pathname) &body body)
  (let ((real (gensym "REAL"))
        (backup (gensym "BACKUP")))
    `(let* ((,real (real-name ,pathname))
            (,backup (backup-name ,real)))
       (unwind-protect
            (prog1
                (with-open-file (,stream ,backup
                                         :direction :output
                                         :element-type '(unsigned-byte 8)
                                         :if-does-not-exist :create
                                         :if-exists :supersede)
                  ,@body)
              (rename-file ,backup ,real :if-exists :supersede))
         (ignore-errors
           (delete-file ,backup))))))

(defmacro with-input-from-backup-file ((stream pathname) &body body)
  (let ((real (gensym "REAL"))
        (backup (gensym "BACKUP"))
        (filename (gensym "FILENAME"))
        (err (gensym "ERR")))
    `(let* ((,real (real-name ,pathname))
            (,backup (backup-name ,real)))
       (flet ((try-file (,filename)
                (with-open-file (,stream ,filename
                                         :direction :input
                                         :element-type '(unsigned-byte 8))
                  ,@body)))
         (handler-case
             (try-file ,real)
           (file-error (,err)
             (cond
               ((equalp (truename ,real)
                        (truename (file-error-pathname ,err)))
                (rename-file ,backup ,real)
                (try-file ,real))
               (t
                (error ,err)))))))))
