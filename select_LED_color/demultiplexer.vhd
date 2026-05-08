library ieee;
use ieee.std_logic_1164.all;

entity demultiplexer is 
    port (
        i_drive_LED: in std_logic;
        i_select_1: in std_logic;
        i_select_2: in std_logic;
        o_LED_blue: out std_logic;
        o_LED_green: out std_logic;
        o_LED_red: out std_logic);
end entity demultiplexer;

architecture demultiplexer_arch of demultiplexer is
begin
    o_LED_blue <= i_drive_LED when i_select_1 = '1' and i_select_2 = '0' else '0';
    o_LED_green <= i_drive_LED when i_select_1 = '0' and i_select_2 = '1' else '0';
    o_LED_red <= i_drive_LED when i_select_1 = '1' and i_select_2 = '1' else '0';
end demultiplexer_arch;
