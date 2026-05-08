library ieee;
use ieee.std_logic_1164.all;

entity demultiplexer_tb is
end entity demultiplexer_tb;

architecture demultiplexer_tb_arch of demultiplexer_tb is
    signal i_tb_drive_LED: std_logic := '0';
    signal i_tb_select_1: std_logic;
    signal i_tb_select_2: std_logic;
    signal o_tb_LED_blue: std_logic;
    signal o_tb_LED_green: std_logic;
    signal o_tb_LED_red: std_logic;
begin
    color_selector: entity work.demultiplexer
    port map( 
        i_drive_LED => i_tb_drive_LED,
        i_select_1 => i_tb_select_1,
        i_select_2 => i_tb_select_2,
        o_LED_blue => o_tb_LED_blue,
        o_LED_green => o_tb_LED_green,
        o_LED_red => o_tb_LED_red);
    
    i_tb_drive_LED <= not i_tb_drive_LED after 1 ns; -- mimic a clock to check all possible combinations
    process is
    begin
        i_tb_select_1 <= '0';
        i_tb_select_2 <= '0';
        report("Both selectors are 0"); 
        wait until rising_edge(i_tb_drive_LED);
        wait for 10 ps; -- wait for clock signal to stabilize
        assert o_tb_LED_blue = '0' report "Incorrect output of LED blue (selectors are 0,0)";
        assert o_tb_LED_green = '0' report "Incorrect output of LED green (selectors are 0,0)";
        assert o_tb_LED_red = '0' report "Incorrect output of LED red (selectors are 0,0)";

        i_tb_select_1 <= '1';
        i_tb_select_2 <= '0';
        report("Selectors are 1, 0"); 
        wait until rising_edge(i_tb_drive_LED);
        wait for 10 ps;
        assert o_tb_LED_blue = '1' report "Incorrect output of LED blue (selectors are 1,0)";
        assert o_tb_LED_green = '0' report "Incorrect output of LED green (selectors are 1,0)";
        assert o_tb_LED_red = '0' report "Incorrect output of LED red (selectors are 1,0)";

        i_tb_select_1 <= '0';
        i_tb_select_2 <= '1';
        report("Selectors are 0, 1"); 
        wait until rising_edge(i_tb_drive_LED);
        wait for 10 ps;
        assert o_tb_LED_blue = '0' report "Incorrect output of LED blue (selectors are 0,1)";
        assert o_tb_LED_green = '1' report "Incorrect output of LED green (selectors are 0,1)";
        assert o_tb_LED_red = '0' report "Incorrect output of LED red (selectors are 0,1)";

        i_tb_select_1 <= '1';
        i_tb_select_2 <= '1';
        report("Selectors are 1, 1"); 
        wait until rising_edge(i_tb_drive_LED);
        wait for 10 ps;
        assert o_tb_LED_blue = '0' report "Incorrect output of LED blue (selectors are 1,1)";
        assert o_tb_LED_green = '0' report "Incorrect output of LED green (selectors are 1,1)";
        assert o_tb_LED_red = '1' report "Incorrect output of LED red (selectors are 1,1)";
    end process;
end architecture demultiplexer_tb_arch;
