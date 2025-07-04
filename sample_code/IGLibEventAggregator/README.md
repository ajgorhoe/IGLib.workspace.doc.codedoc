# Generic Event Aggregator

Copyright (c) Igor Grešovnik

## About Event Aggregator

This is a simple generic event aggregator, launched as learning / experimental project of the Investigative Generic Library. The project was created to experiment with a way to fulfill a specific need in the scope of my professional work at that time.

There might be some extensions of the project in the future. In particular,
asynshronous triggering of events in a parallel thread should be added to cover use cases where filtering and execution of events may be too heavy-wight with respect to the expected maximum frequency of the events (because of which synchronous execution might have negative impacts on other tasks performed by the thread that triggers the events).

