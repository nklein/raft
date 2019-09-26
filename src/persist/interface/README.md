RAFT-PERSIST package
====================

Raft needs to be able to store and retrieve persistent data.
This package defines the interface that Raft expects to use for this purpose.

The persistent data that Raft needs to store is divided between internal state and log entries.
There is a single piece of persistent data for internal state.
There is an ordered list of pieces of persistent data for log entries.


Interface Methods
-----------------

To satisfy Raft's needs, the persistent storage instance must implement the following methods:

    (defgeneric store-state (store bytes)) ; => Nothing
    (defgeneric retrieve-state (store))    ; => BYTES or NIL

    (defgeneric store-log-entry (store index bytes)) ; => Nothing
    (defgeneric retrieve-log-entry (store index))    ; => BYTES or NIL

    (defgeneric clear (store)) ; => Nothing

The `index` values above are non-negative integers.
The `bytes` values above are opaque vector of bytes.

A call to `store-state` should store the given bytes for later retrieval.
This call must either succeed or raise an error of type `store-state-error`.

A call to `retrieve-state` on a store should return exactly the same bytes in the last successful call to `store-state`.

A call to `store-log-entry` should store the given bytes for later retrieval with the given index.
This call must either succeed or raise an error of type `store-log-entry-error`.

A call to `clear` should remove the state and all log entries from the store.
This call must either succeed or raise an error of type `clear-error`.


Error Conditions
----------------

The following condition is the base of all of the errors mentioned above.

    (define-condition persist-error (error)
     ((store :reader persist-error-store
             :initarg :store)
      (reason :reader persist-error-reason
              :initarg :reason
              :type string)
      (inner-error :reader persist-error-inner-error
                   :initarg :inner-error
                   :type error)))

The store error conditions referenced above both share a common parent condition type which adds to the `persist-error`:

    (define-condition store-error (persist-error)
     ((bytes :reader store-error-bytes
             :initarg :bytes
             :type (vector (unsigned-byte 8)))))

The `store-state-error` adds nothing to this base error condition:

    (define-condition store-state-error (store-error)
     ())

The `store-log-entry-error` adds the log entry's index to the base error condition:

    (define-condition store-log-entry-error (store-error)
     ((index :reader store-log-entry-error-index
             :initarg :index
             :type (integer 0))

The `clear-error` referenced above adds nothing to the base error.

    (define-condition clear-error (persist-error)
     ())
