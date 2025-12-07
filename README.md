# FPGA-101
Simple code examples in VHDL for FPGA development.
Dedicated code creates look-up tables for doing the corresponding boolean algebra (i.e., logic gates **do not** physicsally exist inside the FPGA).
Together with flip-flops (to keep information about the machine state), the FPGA's magic becomes possible.
The data is stored inside embedded block RAM.

## FPGA Model

Zunq-7000 &s CLG400 FPGA on a Digilent Zora z7s Zynq development board.

## Timing 

Precise timing is important for sequential (that is, driven by a clock) logic.
E.g., propagation of a signal between two consequent flip-flops cannot be longer than 1 clock period.
Adding more logic between two elements results in a longer signal propagation delay, 
so the logic should be broken up into smaller stages - **pipelines**.

The minimal clock cycle period (equivalently, the maximum clock frequency) is defined by the summ of the setup time,
 hold time, and the propagation delay. The former two are fixed by the design of the flip-flops,
nly the latter can be controlled.

Failing to properly meet timing requirements will result in flip-flops possibly entering a *metastable* state.
The FPGA will then not operate in the intended way.
A situtation where a metastable state is possible can be fixed by cascading the data through 2 consequent flip-flops.

## Defining Constraints

To map inputs and outputs in the code to physical pins on the board, one must use a constraints file (*.xdc* extension).

First one defines the clock. The following example maps the physical pin (pin *H16*, can be found in the board schematics)
to a VHDL variable *i_clock*, then defines a system clock with a given period (in ns) and rise and fall times of the square signal (here at 0 and 5 ns, respectively):

```VHDL
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { i_clock }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { i_clock }];
```
Now the variable *i_clock* can be used inside the VHDL code. Similar code (first line, but with a different pin and variable name).

The constaints master file for most commmon boards can be found at [the Digilent GitHub](https://github.com/Digilent/digilent-xdc).
All pins are already mapped there, just uncomment the required ones.

## VHDL Syntax Fundamentals 

The code below can be found as an elcosed project in the ```and_gate/``` folder.

Initially, one must use libraries to define the behaviour of keywords:

```VHDL
library ieee;
use ieee.std_logic_1164.all;
```
All input and output signals are defined inside an **entity** block:

```VHDL
entity example_and_gate is
    port (
        input_1: in std_logic;
        input_2: in std_logic;
        and_result: out std_logic
    );
end example_end_gate;
```

 The functionality of an entity is described in an **architecture**:

```VHDL
architecture arch_and_gate of example_and_gate is
    signal and_gate: std_logic;
begin
    and_gate <= input_1 and input_2;
    and_result <= and_gate;
end arch_end_gate;
```

A **signal** is a fundamental unit of VHDL.

A process can be declared as follows:

```VHDL
process (input_1, input_2) -- this sensitivity list defines which signals will cause the block to execute
begin
    and_gate <= input_1 and input_2;
end process;
```

The VHDL code will be translated into some logical elements with the help of a *synthesis tool*.


## Simulating The Design

To simulate a design, test inputs are provided via a **testbench** - code that checks which outputs are triggered for given inputs.
For a testbench, there are no input or output signals to be defined since all signals are generated internally.

## Synthesis And Implementation

Initially, **synthesis** converts the VHDL/Verilog code into a series of abstract flip-flops and logic gates.
These elements are then mapped to physical components inside the FPGA durind the **implementation** phase. 
Finally, the **bistream** process generates a *.bit* file that can be uploaded to the FPGA.

## Programming The Device

The generated bitsream can be uploaded to the FPGA board using a hardware manager. IDEs may already include that. Choose the *.bit* file 
and upload it to the board.

## Sources

Have a look at [NANDland](https://nandland.com/)
