RAFT-COMMUNICATE package
========================

Raft needs to exchange messages with its peers.
This package defines the interface the server will use to send a message to a given peer.

Interface Methods
-----------------

To satisfy Raft's needs, the update instance must implement the following method:

    (defgeneric send-to-peer (sender peer-handle bytes)) ; => Nothing

The `peer-handle` is provided to the Raft server.
The Raft server itself does not have any requirements on what constitutes a peer handle beyond that it uniquely identify a peer.
The `bytes` value above in an opaque vector of bytes.

Example
-------

If, for example, the `sender` is a datagram socket and the `peer-handle` is a cons, then this method could be implemented as:

    (defmethod update ((sender usocket:datagram-usocket) peer-handle bytes)
      (usocket:socket-send sender bytes (length bytes)
                           :host (car peer-handle)
                           :port (cdr peer-handle)))
