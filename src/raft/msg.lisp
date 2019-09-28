;;; src/raft/msg.lisp

(in-package #:raft)

(defmacro define-assoc-reader (name (keyword &key default))
  (check-type name symbol)
  (check-type keyword keyword)
  (let ((maker (intern (format nil "MAKE-~A" name)
                       (package-name (symbol-package name)))))
    `(progn
       (declaim (inline ,name))
       (defun ,name (x)
         (let ((entry (assoc ,keyword x)))
           (if entry
               (cdr entry)
               ,default)))

       (declaim (inline ,maker))
       (defun ,maker (x)
         (cons ,keyword x)))))

(defgeneric encode-payload (type data stream)
  (:method (type data stream)
    (declare (ignore type data stream))
    nil))

(defgeneric decode-payload (type stream)
  (:method (type stream)
    (declare (ignore type stream))
    nil))

;;; opaque sequence of bytes
(define-assoc-reader opaque-length (:length :default 0))

(defmethod encode-payload ((type (eql :opaque)) data stream)
  (check-type data (vector (unsigned-byte 8)))
  (let ((opaque-header (list (make-opaque-length (length data)))))
    (with-standard-io-syntax
      (write opaque-header :stream stream))
    (write-sequence data stream)))

(defmethod decode-payload ((type (eql :opaque)) stream)
  (let* ((opaque-header (with-standard-io-syntax
                          (read stream)))
         (length (opaque-length opaque-header))
         (array (make-array length :element-type '(unsigned-byte 8))))
    (read-sequence array stream :start 0 :end length)
    (coerce array '(vector (unsigned-byte 8)))))

;;; whole messages
(define-assoc-reader wrapper-msg-type (:msg-type))
(define-assoc-reader wrapper-msg (:msg))
(define-assoc-reader wrapper-data-type (:data-type))

(defun encode-message (msg-type msg &optional data-type data)
  (string-to-utf-8-bytes
   (with-output-to-string (out)
     (let ((wrapper (list (make-wrapper-msg-type msg-type)
                          (make-wrapper-msg msg)
                          (make-wrapper-data-type data-type))))
       (with-standard-io-syntax
         (write wrapper :stream out)))
     (encode-payload data-type data out))))

(defun decode-message (encoded-msg)
  (with-input-from-string (in (utf-8-bytes-to-string encoded-msg))
    (let* ((wrapper (with-standard-io-syntax
                      (read in)))
           (msg-type (wrapper-msg-type wrapper))
           (msg (wrapper-msg wrapper))
           (data-type (wrapper-data-type wrapper))
           (payload (decode-payload data-type in)))
      (values msg-type
              msg
              payload))))
