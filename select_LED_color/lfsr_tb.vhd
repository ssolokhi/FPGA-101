library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr_tb is
end entity lfsr_tb;

architecture lfsr_tb_arch of lfsr_tb is
    signal tb_clock: std_logic := '0'; -- will fail without initial value!
    signal w_done: std_logic;
begin
    lfsr_3_bit: entity work.lfsr
    generic map (c_LFSR_BITS => 3) -- 3 bits chosen to profit from short simulation run time
    port map(
        i_clock => tb_clock,
        o_done => w_done
    ); 

    tb_clock <= not tb_clock after 1 ns;
    process is 
    begin
        wait for 10 ns;
    end process;
end architecture lfsr_tb_arch;

