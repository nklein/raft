RAFT package
============

Raft is a consensus algorithm for managing a replicated log of changes to shared state.
Details about the algorithm can be found in this paper:
[In Search of an Understandable Consensus Algorithm][raft]
by Diego Ongaro and John Ousterhout.
A more user-friendly description of the algorithm is available
on this site: [Raft at Github.IO][git]

[raft]: https://ramcloud.atlassian.net/wiki/download/attachments/6586375/raft.pdf
[git]: https://raft.github.io

Helper Interfaces
-----------------

The Raft server needs to interact with persistent storage, the local shared state, and its peer servers.
To accomplish this in the most agnostic manner possible, it depends on abstract interfaces.

For persistent storage, it depends on the [`raft-persist`][rp-api] interface.
For interacting with the local shared state, it depends on the [`raft-update`][ru-api] interface.
For interacting with its peers, it depends on the [`raft-communicate`][rc-api] interface.

[rp-api]: src/persist/interface/README.md
[ru-api]: src/update/interface/README.md
[rc-api]: src/communicate/interface/README.md

Creating A Raft Server Instance
-------------------------------

To create a Raft server instance, one uses the following method:

    (defun make-raft-server (id
                             &key
                               persist-instance
                               update-instance
                               communicate-instance
                               (election-timeout 4)
                               (broadcast-timeout 1)) ...)

The `id` is a unique identifier for this server.
This value is used in communications with the server's peers.
This value must be printable and readable under `with-standard-io-syntax`.
Furthermore, the `id` must be `equalp` to a printed and read copy of itself.

The `persist-instance` is required and must implement the [`raft-persist`][rp-api] interface.

The `update-instance` is required and must implement the [`raft-update`][ru-api] interface.

The `communicate-instance` is required and must implement the [`raft-communicate`][rc-api] interface.

The `election-timeout` specifies the number of seconds which can elapse without a group leader.
This value must be at least `+minimum-election-timeout+` seconds.
The longer this is, the longer the group will take to recover from the loss of its leader.

The `broadcast-timeout` specifies the number of seconds between heartbeat messages from the group leader.
This must be a third as long as the `election-timeout` or less.
State updates happen with heartbeat messages.
As such, the longer this is, the longer some clients will stay out of date.

Handling Timers and Messages For The Raft Server
------------------------------------------------

The Raft server needs to perform some tasks periodically.
Your application needs to invoke the following method regularly to allow the server a chance to perform those tasks:

    (defun process-timers (server) ...) => seconds

This method will return the number of seconds from now that it expects to be invoked next.

The Raft server sends messages to its peers using the `communicate-instance` that it was given when constructed.
This allows the Raft server to send messages.
That instance does not allow the Raft server to receive messages.

Your application needs to have some way of receiving messages for the Raft server.
When your application receives a message for the Raft server, it must invoke the following method:

    (defun process-msg (server peer-handle encoded-msg) ...)

The `peer-handle` is the handle of the peer who sent the message.

The `encoded-msg` is the message the peer passed to `raft-communicate:send-to-peer`.
The `encoded-msg` is a `vector` of `(unsigned-byte 8)`.
