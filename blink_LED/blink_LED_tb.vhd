library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blink_LED_tb is
end blink_LED_tb;

architecture behave of led_blink_tb is
    constant c_CLOCK_PERIOD: time := 10 ns;

    signal r_CLOCK: std_logic := '0';
    signal r_ENALBE_LED: std_logic := '0';
    signal r_SELECT_FREQ: std_logic := '0';
    signal r_LED_SIGNAL: std_logic;

    -- component defines the nature of an entity somewhere in the design
    component blink_LED is
        port (
            i_clock: in std_logic;
            i_enable_LED: in std_logic;
            i_select_frequency: in std_logic;
            o_LED_signal: out std_logic;
             );
    end component blink_LED;

begin
    -- instantiate the UUT
    UUT: blink_LED
        port map (
            i_clock => r_CLOCK,
            i_enable_LED => r_ENABLE,
            i_select_frequency => r_SELECT_FREQ,
            o_LED_signal => w_LED_SIGNAL
        );
    
        p_CLK_GEN: process is
        begin 
            wait for c_CLOCK_PERIOD / 2;
            r_CLOCK <= not r_CLOCK;
        end process p_CLK_GEN;

        -- main testing
        process
        begin
            r_ENALBE_LED <= '1';

            r_SELECT_FREQ <= '0';
            wait for 2 sec;

            r_SELECT_FREQ <= '1';
            wait for 0.2 sec;
        end process;
end behave;
