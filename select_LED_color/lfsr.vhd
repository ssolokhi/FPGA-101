library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr is 
    generic (c_LFSR_BITS: natural := 20);
    port (
        i_clock: in std_logic;
        o_done: out std_logic);
end entity lfsr;

architecture lfsr_arch of lfsr is 
    signal r_LFSR: std_logic_vector(c_LFSR_BITS-1 downto 0) := (others => '0');
    signal r_array_of_zeros: std_logic_vector(c_LFSR_BITS-1 downto 0) := (others => '0');
    signal w_XNOR_gate: std_logic;
begin 
    process (i_clock) is
    begin
        if rising_edge(i_clock) then
            r_LFSR <= r_LFSR(c_LFSR_BITS-2 downto 0) & w_XNOR_gate;
        end if;
    end process;
    w_XNOR_gate <= r_LFSR(c_LFSR_BITS-1) xnor r_LFSR(c_LFSR_BITS-2);
    o_done <= '1' when (r_LFSR = r_array_of_zeros) else '0'; -- check that r_LFSR is an array of 0's
end architecture lfsr_arch;
