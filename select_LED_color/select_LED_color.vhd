library ieee;
use ieee.std_logic_1164.all;

entity select_LED_color is
    port(
        i_clock: in std_logic;
        i_button_1: in std_logic;
        i_button_2: in std_logic;
        o_LED_blue: out std_logic; 
        o_LED_green: out std_logic; 
        o_LED_red: out std_logic);
end entity select_LED_color;

architecture select_LED_color_arch of select_LED_color is 
    signal r_LFSR_toggle: std_logic := '0';
    signal w_LFSR_done: std_logic;
begin
    lsfr_25_bits: entity work.lfsr
    generic map (c_LFSR_BITS => 25)
    port map(
        i_clock => i_clock,
        o_done => w_LFSR_done);
    process (i_clock) is 
    begin
        if rising_edge(i_clock) then
            if w_LFSR_done = '1' then
                r_LFSR_toggle <= not r_LFSR_toggle;
            end if;
        end if;
    end process;
    color_selector: entity work.demultiplexer
    port map(
        i_drive_LED => r_LFSR_toggle,
        i_select_1 => i_button_1,
        i_select_2 => i_button_2,
        o_LED_blue => o_LED_blue,
        o_LED_green => o_LED_green,
        o_LED_red => o_LED_red);
end architecture select_LED_color_arch;
