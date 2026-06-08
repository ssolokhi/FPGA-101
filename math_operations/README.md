# Mathematical Operations

By default, all numbers are *unsigned*. In a signed number, the first bit represents the sign: "0" for positive, "1" for negative.

To figure out which decimal value is represented by a negative number, one must invert all bits and add 1. E.g., 101 represents -3; 
inverting the bits gives 010, adding 1 yields 011 = -3. The inverse is also true: to convert a negative number to its  binary
 representation, take the binary representation of the unsigned number, invert the bits, then add 1.

## Type Conversion

Contrast to Verilog, VHDL is strongly typed, so explicit type conversions are needed.

## Addition

First rule prevents overflow due to the carry:

> [!IMPORTANT]
> The addition (or subtraction) result should be 1 bit bigger than the inputs **before** sign extention

Here sign extension refers to replicating the most significant bit to the left, e.g. "1000" -> "11000".
 It is only needed for signed numbers. In VDHL, this is done with the *resize()* function.

> [!IMPORTANT]
> Types of inputs and outputs must match

## Subtraction

To avoid e.g., storing a negative number as a fake positive integer,

> [!IMPORTANT] 
> Only perform subtraction between signed types

## Multiplication 

> [!IMPORTANT]
> The multiplication result must be at least as wide as the sum of input widths **before** sign extention

This rule holds for unsigned as well as signed numbers.

### Bit shifts

Multiplications/divisions by powers of 2 can be performed by shifting the bits left/right.
Such an operation saves computational resources compared to regular multiplication.

## Division

While division in FPGAs is not simple, dividing by powers of 2 can also be efficiently performed by bit shifts to the right.
If a number is not divisible by this power of 2, the result will be rounded down.

An alternative approach is to create a table containing pre-calculated division results for all combinations of inputs.

## Using Floating-Point Numbers

To store floating-point numbers, one can decide that some bits are used to store the integer part and some - the fractional part.
This can be represented with the *Q-notation*: e.g., Q1.2 means that 1 bit is used for the integer part and 2 for the fractional one.

If there are *N* bits allocated for the fractional part, take the integer value from the "normal" bit representation,
then divide by $2^N$. E.g., in Q0.3 111 corresponds to $\frac{7}{2^3} = 0.875$. This logic can be extended to signed integers.

> [!IMPORTANT]
> When adding or subtracting floating-point numbers, the input widths must match

For multiplication, the previous rule is also extended:

> [!IMPORTANT]
> The multiplication result must be at least as wide as the sum of input widths - both for the integer and the fractional parts.
