library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blink_LED is
    port (
        i_clock: in std_logic;
        i_enable_LED: in std_logic;
        i_select_frequency: in std_logic;
        o_LED_signal: out std_logic;
         );
end blink_LED;

architecture arch_blink_LED of blink_LED is
    signal w_SELECT_LED: std_logic; -- 1 bit for turning LED on\off

    -- use 100 MHz clock with 50% duty cycle:
    constant c_CLOCK_FREQ: natural := 100000000;
    constant c_CNT_1HZ: natural := 50000000;
    constant c_CNT_10HZ: natural := 5000000;

    -- define counters:
    signal r_CNT_1HZ: natural range 0 to c_CNT_1HZ;
    signal r_CNT_10HZ: natural range 0 to c_CNT_10HZ;

    signal r_TOGGLE_1HZ: std_logic := '0';
    signal r_TOGGLE_10HZ: std_logic := '0';
begin
    -- both processes will run at all times
    p_1_HZ: process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if r_CNT_1HZ = c_CNT_1HZ - 1 then -- check for overflow; -1 because counter starts at 0
                r_TOGGLE_1HZ <= not r_TOGGLE_1HZ;
                r_CNT_1HZ <= 0;
            else
                r_CNT_1HZ <= r_CNT_1HZ + 1; 
            end if;
        end if;
    end process p_1_HZ;

    p_10_HZ: process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if r_CNT_10HZ = c_CNT_10HZ - 1 then -- check for overflow; -1 because counter starts at 0
                r_TOGGLE_10HZ <= not r_TOGGLE_10HZ;
                r_CNT_10HZ <= 0;
            else
                r_CNT_10HZ <= r_CNT_10HZ + 1; 
            end if;
        end if;
    end process p_10_HZ;

    -- multiplexer for choosing frequency
    w_SELECT_LED <= r_TOGGLE_10HZ when (i_select_frequency = '1') else r_TOGGLE_1HZ;
    o_LED_signal <= i_enable_LED and w_SELECT_LED;
end arch_blink_LED;
