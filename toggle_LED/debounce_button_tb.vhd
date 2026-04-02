library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity debounce_button_tb is -- there are no real I\O, so port list is empty
end entity debounce_button_tb;

architecture debounce_tb_arch of debounce_button_tb is
    signal r_tb_clock, r_tb_raw_button, w_tb_debounced_button: std_logic := '0';
begin
    r_tb_clock <= not r_tb_clock after 1 ns; -- emulate clock for this TB
    UUT: entity work.debounce_button
    generic map (c_DEBOUNCE_LIMIT => 3) -- chosen arbitrarily
    port map (
        i_clock => r_tb_clock,
        i_raw_button => r_tb_raw_button,
        o_debounced_button => w_tb_debounced_button);
    process is
    begin
        wait for 5 ns;
        r_tb_raw_button <= '1'; -- simulate button push
        wait until rising_edge(r_tb_clock); 
        r_tb_raw_button <= '0'; -- simulate bouncing of the button's signal
        wait until rising_edge(r_tb_clock);
        r_tb_raw_button <= '1'; -- remove bouncing
        wait for 10 ns;
        finish;
    end process;
end architecture debounce_tb_arch;
