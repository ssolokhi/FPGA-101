library ieee;
use ieee.numeric_std.all; -- contains conversion functions
use ieee.std_logic_1164.all;
use std.env.finish;

entity math_operations_tb is 
end entity math_operations_tb;

architecture math_operations_tb_RTL of math_operations_tb is 
    -- return string for printing unsigned number
    function str(value: in unsigned) return string is 
    begin
        return to_string(to_integer(value));
    end function str;
     -- return string for printing unsigned number
    function str(value: in signed) return string is 
    begin
        return to_string(to_integer(value));
    end function str;
    -- return string for printing unsigned number
    function str(value: in real) return string is 
    begin
        return to_string(value, "%2.3f");
    end function str;
begin
    process is
        variable i1_u4, i2_u4, o_u4: unsigned(3 downto 0);
        variable i1_u5, i2_u5, o_u5: unsigned(4 downto 0);
        variable i1_u6, i2_u6, o_u6: unsigned(5 downto 0);
        variable i1_s4, i2_s4, o_s4: signed(3 downto 0);
        variable i1_s5, i2_s5, o_s5: signed(4 downto 0);
        variable i1_u8, o_u8: unsigned(7 downto 0);
        variable i1_s8, o_s8: signed(7 downto 0);
        variable o_r1, o_r2, o_r3: real;
    begin
        -- adding two unsigned numbers incorrectly
        i1_u4 := "1001"; -- blocking operator to ensure correct order of execution
        i2_u4 := "1011";
        o_u4 := i1_u4 + i2_u4;
        report "Added " & str(i1_u4) & " + " & str(i2_u4) & " =/= " & str(o_u4);
        -- adding two signed numbers incorrectly
        i1_s4 := "1001";
        i2_s4 := "1011";
        o_s4 := i1_s4 + i2_s4;
        report "Added " & str(i1_s4) & " + " & str(i2_s4) & " =/= " & str(o_s4);

        -- adding two unsigned numbers correctly
        i1_u4 := "1001"; -- blocking operator to ensure correct order of execution
        i2_u4 := "1011";
        i1_u5 := resize(i1_u4, i1_u5'length);
        i2_u5 := resize(i2_u4, i2_u5'length);
        o_u5 := i1_u5 + i2_u5;
        report "Added " & str(i1_u5) & " + " & str(i2_u5) & " = " & str(o_u5);
        -- adding two signed numbers correctly
        i1_s4 := "1001";
        i2_s4 := "1011";
        i1_s5 := resize(i1_s4, i1_s5'length);
        i2_s5 := resize(i2_s4, i2_s5'length);
        o_s5 := i1_s5 + i2_s5;
        report "Added " & str(i1_s5) & " + " & str(i2_s5) & " = " & str(o_s5);

        -- subtracting two unsigned numbers
        i1_u4 := "1001"; 
        i2_u4 := "1011";
        i1_u5 := resize(i1_u4, i1_u5'length);
        i2_u5 := resize(i2_u4, i2_u5'length);
        o_u5 := i1_u5 - i2_u5;
        report "Subtracted " & str(i1_u5) & " - " & str(i2_u5) & " =/= " & str(o_u5);
        -- subtracting two signed numbers correctly
        i1_u4 := "1001";
        i2_u4 := "1011";
        i1_s5 := signed(resize(i1_u4, i1_s5'length));
        i2_s5 := signed(resize(i2_u4, i2_s5'length));
        o_s5 := i1_s5 - i2_s5;
        report "Subtracted " & str(i1_s5) & " + " & str(i2_s5) & " = " & str(o_s5);

        -- multiplying two unsigned numbers
        i1_u4 := "1001"; -- blocking operator to ensure correct order of execution
        i2_u4 := "1011";
        o_u8 := i1_u4 * i2_u4;
        report "Multiplyed " & str(i1_u4) & " * " & str(i2_u4) & " = " & str(o_u8);
        -- multipying two signed numbers
        i1_u4 := "1001";
        i2_u4 := "1011";
        o_s5 := i1_s4 * i2_s4;
        report "Subtracted " & str(i1_s4) & " * " & str(i2_s4) & " = " & str(o_s8);

        -- multiplying using bit shifts
        i1_u8 := to_unsigned(3, i1_u8'length);
        o_u8 := shift_left(i1_u8, 1);
        report "bit-shifted to the left " & str(i1_u8) & " * 2 = " & str(o_u8);
        o_u8 := shift_left(i1_u8, 2);
        report "bit-shifted to the left " & str(i1_u8) & " * 4 = " & str(o_u8); 
        o_u8 := shift_left(i1_u8, 3);
        report "bit-shifted to the left " & str(i1_u8) & " * 8 = " & str(o_u8);
 
        -- dividing using bit shifts
        i1_u8 := to_unsigned(12, i1_u8'length);
        o_u8 := shift_right(i1_u8, 1);
        report "bit-shifted to the right " & str(i1_u8) & " / 2 = " & str(o_u8);
        o_u8 := shift_right(i1_u8, 2);
        report "bit-shifted to the right " & str(i1_u8) & " / 4 = " & str(o_u8); 
        o_u8 := shift_right(i1_u8, 3);
        report "bit-shifted to the right " & str(i1_u8) & " / 8 = " & str(o_u8) & " (result rounded down)";
 
        -- adding two floating-point numbers incorrectly
        i1_u4 := "1001"; -- Q3.1 
        i2_u4 := "1011"; -- 4.0
        i1_u5 := resize(i1_u4, i1_u5'length);
        i2_u5 := resize(i2_u4, i2_u5'length);
        o_u5 := i1_u5 + i2_u5;
        o_r1 := real(to_integer(i1_u5)) / 2.0; -- because the fractional part has bit width 1 => divide by 2^1 = 2
        o_r2 := real(to_integer(i2_u5)); -- because the fractional part has bit width 0 => divide by 2^0 = 1
        o_r3 := real(to_integer(o_u5)) / 2.0;
        report "Added floating-point numbers " & str(o_r1) & " + " & str(o_r2) & " =/= " & str(o_r3);
        -- adding two floating-point numbers correctly
        i1_u4 := "1001"; -- Q3.1
        i2_u4 := "1011"; -- Q4.0
        i1_u6 := resize(i1_u4, i1_u6'length); -- expand for addition
        i2_u6 := resize(i2_u4, i2_u6'length);
        i2_u6 := shift_left(i2_u6, 1); -- convert Q4.0 to Q4.1
        o_u6 := i1_u6 + i2_u6;
        o_r1 := real(to_integer(i1_u6)) / 2.0; -- synthesis tools are smart enough to infer a bit shift
        o_r2 := real(to_integer(i2_u6)) / 2.0;
        o_r3 := real(to_integer(o_u6)) / 2.0;
        report "Added floating-point numbers " & str(o_r1) & " + " & str(o_r2) & " = " & str(o_r3);

        -- multiplying two floating-point numbers correctly
        i1_u4 := "1001"; -- Q2.2
        i2_u4 := "1011"; -- Q3.1
        -- multiplication result will be Q5.3
        o_u6 := i1_u4 * i2_u4;
        o_r1 := real(to_integer(i1_u4)) / 4.0; 
        o_r2 := real(to_integer(i2_u4)) / 2.0;
        o_r3 := real(to_integer(o_u8)) / 8.0;
        report "Multiplied floating-point numbers " & str(o_r1) & " + " & str(o_r2) & " = " & str(o_r3);

        wait for 1 ns;
        finish;
    end process;
end architecture math_operations_tb_RTL;
