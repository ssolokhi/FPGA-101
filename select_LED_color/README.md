    Here, a particular color of the LED is chosen based on the user's input. 

The color is selected using signals from 2 buttons. If none is pushed, the LED stays off.
Pushing either of the buttons or both selects one of the 3 colors. This is achieved using a 1-to-4 demultiplexer.

The LED should stay on for about a second. The delay is implemented not with a clock cycle counter,
but using a *linear feedback shift register* (LFSR), which will loop through all its states in 
$2^n - 1$ clock cycles, where $n$ is the number of bits in the LFSR. Using a 100 MHz clock, 
a 25-bit LFSR results in a 0.33 seconds delay, suitable for the project.

While the LFSR is not very flexible (for instance, it cannot have cycle length outside the formula above), 
but it is used here as an example of what is possible to implement. In addition, LSFRs use less flip-flops and look-up tables
when compared to regular counters, which may be useful when resources are scarse.
