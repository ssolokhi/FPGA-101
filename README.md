# FPGA-101
Simple code examples in VHDL for FPGA development 

## FPGA Model

Digilent Zora z7s - lowcost Zynq development board

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

## Simulating The Design

To simulate a design, test inputs are provided via a test bench.

## Sources

Have a look at [NANDland](https://nandland.com/)
