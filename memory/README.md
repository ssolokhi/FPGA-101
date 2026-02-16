One of the examples shows how to define a *random-access memory* (RAM) unit for storing data:
a block of width ** (bit size of each storage address) and depth ** (determines the number of avaiable addresses).
"Random" refers to the fact that there is no defined order in which the data must be inserted/retrieved.
This particular implementation is *dual-port*, meaning that writing and reading is allowed in the same clock cycle.  
Both ports in general may use a separate dedicated clock.

The synthesis tool will decide whether the RAM block will be implemented as an array of flip-flops (suitable for small sizes)
or as block RAM.

The next example shows how to create a *first in - first out* (FIFO) that implements a queue: entries that where written to memory
first will be read out first. FIFO structures are commonly used to cross clock domains. The two rules of using a FIFO are:

1. Do not write to a full FIFO (will cause data loss);

2. Do not read from an empty FIFO (will spit out a random data sequence).
