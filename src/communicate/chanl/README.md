RAFT-COMMUNICATE-CHANL package
==============================

The package implements the [`raft-communicate` interface][rp-api] using `CHANL` communication channels.

[rp-api]: ../interface/README.md

To create an instance, use the following function:

    (defun make-communicate-chanl () ...)

The peer handles must return a `CHANL` channel when passed to the method:

    (defgeneric chanl (peer-handle))
