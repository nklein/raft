RAFT-UPDATE package
===================

At its core, Raft is a consensus-based state-sharing mechanism.
Raft maintains a log of changes to the shared state.
Raft messages make changes to the shared state.
The Raft server itself is agnostic about what state is saved and what messages are used to change the state.

This package defines the interface the Raft server uses to provide change log entries to whatever entity is responsible for effecting those changes in the local copy of the shared state.

Interface Methods
-----------------

To satisfy Raft's needs, the update instance must implement the following method:

    (defgeneric update (updater bytes)) ; => Nothing

The `bytes` value above in an opaque vector of bytes.

Example
-------

If, for example, the shared state were simply an integer and the log messages were simply changes to the integer, the update function might look something like:

    (defmethod update ((updater shared-integer-holder) bytes)
      (let ((string (map 'string #'code-char bytes)))
        (incf (shared-value updater) (parse-integer string))))

Obviously, for more complicated state, turning the `bytes` into something actionable will take more care.
