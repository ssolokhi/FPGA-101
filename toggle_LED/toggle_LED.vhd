library ieee;
use ieee.std_logic_1164.all;

entity toggle_LED is 
    port (
        i_clock: in std_logic;
        i_raw_button: in std_logic;
        o_toggle_LED: out std_logic
    );
end entity toggle_LED;

architecture toggle_arch of toggle_LED is
    signal w_toggle_LED: std_logic;
    signal r_switch, r_toggle_LED: std_logic := '0';
begin
    debounce_button_inst: entity work.debounce_button
    generic map(
        c_DEBOUNCE_LIMIT => 250000)
    port map(
        i_clock => i_clock,
        i_raw_button => i_raw_button,
        o_debounced_button => w_toggle_LED);
    process (i_clock) is
    begin
        if rising_edge(i_clock) then 
            r_switch <= i_raw_button;
            if w_toggle_LED = '0' and r_switch = '1' then -- condition of button release since reg wasn't updated yet
                r_toggle_LED <= not r_toggle_LED;
            end if;
        end if;
    end process;
    o_toggle_LED <= r_toggle_LED; 
end architecture toggle_arch;
