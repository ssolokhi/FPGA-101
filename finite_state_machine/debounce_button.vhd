library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_button is 
    generic (c_DEBOUNCE_LIMIT: integer := 100);
    port(
        i_clock: in std_logic;
        i_raw_button: in std_logic;
        o_debounced_button: out std_logic
    );
end entity debounce_button;

architecture debounce_arch of debounce_button is
    signal r_counter: integer range 0 to c_DEBOUNCE_LIMIT := 0;
    signal r_current_state: std_logic := '0';
begin
    process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if (i_raw_button /= r_current_state and r_counter < c_DEBOUNCE_LIMIT - 1) then
                r_counter <= r_counter + 1;
            elsif r_counter = c_DEBOUNCE_LIMIT - 1 then
                r_current_state <= i_raw_button;
                r_counter <= 0;
            else 
                r_counter <= 0;
            end if;
        end if;
    end process;
    o_debounced_button <= r_current_state;
end architecture debounce_arch;
