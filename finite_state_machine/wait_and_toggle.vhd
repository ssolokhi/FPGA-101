library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wait_and_toggle is 
    generic (c_N_CYCLES_TO_WAIT: natural := 10000);
    port (
        i_clock: in std_logic;
        i_enable_counter: in std_logic;
        o_toggle: out std_logic);
end entity wait_and_toggle;

architecture wait_and_toggle_RTL of  wait_and_toggle is 
    signal r_counter: natural range 0 to c_N_CYCLES_TO_WAIT;
begin
    process (i_clock) is 
    begin
        if rising_edge(i_clock) then
            if i_enable_counter = '1' then 
                if r_counter = c_N_CYCLES_TO_WAIT -1 then
                    o_toggle <= not o_toggle;
                    r_counter <= 0;
                else
                    r_counter <= r_counter + 1;
                end if;
            else
                o_toggle <= '0';
            end if;
        end if;
    end process;   
end architecture wait_and_toggle_RTL;
