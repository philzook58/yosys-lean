# Elastic transformation stage

`Pipeline.v` is an original one-entry ready/valid queue that stores
`5*x + 1` modulo 2^16. It supports backpressure and simultaneous drain/refill.
Reset clears occupancy and suppresses both handshakes; the data register is
uninitialized and irrelevant while empty.

`Examples/ElasticProofs.lean` proves a transaction conservation equation for
arbitrary finite reset-free traces and arbitrary initial occupancy:

    initially pending ++ transformed accepted = emitted ++ finally pending

From empty, emitted values are an ordered prefix of transformed accepted
inputs, with the exact remaining suffix in the queue. This proves no loss,
duplication, or reordering under arbitrary bubbles and backpressure. It also
proves capacity at most one, state stability when stalled, and reset flushing.
There is no eventual-delivery claim without an environment readiness condition.

This is a small original example inspired by elastic pipeline and FIFO demos,
not a translation of Kôika, Bluespec, or Sparkle source. Tests compare actual
Lean evaluation, Icarus RTL simulation, and a Python queue scoreboard.
