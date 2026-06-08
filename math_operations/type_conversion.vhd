library ieee;
use ieee.numeric_std.all; -- contains conversion functions
use ieee.std_logic_1164.all;

entity type_conversions is 
    port (
        signal i1_u4: in unsigned(3 downto 0); -- unsigned input, 4 bits wide => name of variable
        signal i2_u4: in unsigned(3 downto 0); -- similar for all variables
        signal i3: integer;
        signal i4_lv4: in std_logic_vector(3 downto 0); -- similar for all variables

        signal o1: out integer;
        signal o2_u4: out unsigned(3 downto 0);
        signal o3_s4: out signed(3 downto 0);
        signal o4_lv4: out std_logic_vector(3 downto 0)
         );
end entity type_conversions;

architecture type_conversions_RTL of type_conversions is 
begin
    o1 <= to_integer(i1_u4);

    -- from integers:
    o2_u4 <= to_unsigned(i3, o2_u4'length); -- output width required for correct sizing
    o3_s4 <= to_signed(i3, o3_s4'length);
    o4_lv4 <= std_logic_vector(to_unsigned(i3, o4_lv4'length)); -- for positive numbers
    o4_lv4 <= std_logic_vector(to_signed(i3, o4_lv4'length)); -- for negative numbers

    -- from std_logic_vector:
    o2_u4 <= unsigned(i4_lv4);
    o3_s4 <= signed(i4_lv4);
    o1 <= to_integer(unsigned(i4_lv4));

end architecture type_conversions_RTL;
