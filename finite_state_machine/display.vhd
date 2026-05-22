library ieee;
use ieee.std_logic_1164.all;

entity segmented_display is 
    port (
    i_clock: in std_logic;
    i_binary_to_display: in std_logic_vector(3 downto 0); -- 4 bits to hold 16 inputs from 0x0 to 0xF
    o_segment_a: out std_logic;
    o_segment_b: out std_logic;
    o_segment_c: out std_logic;
    o_segment_d: out std_logic;
    o_segment_e: out std_logic;
    o_segment_f: out std_logic;
    o_segment_g: out std_logic
    );
end entity segmented_display;

architecture segmented_display_RTL of segmented_display is
    signal r_hex_encoding: std_logic_vector(6 downto 0); -- 7 bits - one for each 
begin
    process (i_clock) is
    begin
        if rising_edge(i_clock) then
            case i_binary_to_display is
                -- encoding A to G goes from most significant bit to least significant
                -- to verify correctness, draw the display with correctly mapped
                -- ports and see which segments should light up
                when "0000" => r_hex_encoding <= "1111110";
                when "0001" => r_hex_encoding <= "0110000";
                when "0010" => r_hex_encoding <= "1101101";
                when "0011" => r_hex_encoding <= "1111001";

                when "0100" => r_hex_encoding <= "0110011";
                when "0101" => r_hex_encoding <= "1011011";
                when "0110" => r_hex_encoding <= "1011111";
                when "0111" => r_hex_encoding <= "1110000";
                
                when "1000" => r_hex_encoding <= "1111111";
                when "1001" => r_hex_encoding <= "1111011";
                when "1010" => r_hex_encoding <= "1110111";
                when "1011" => r_hex_encoding <= "0011111";
                
                when "1100" => r_hex_encoding <= "1001110";
                when "1101" => r_hex_encoding <= "0111101";
                when "1110" => r_hex_encoding <= "1001111";
                when "1111" => r_hex_encoding <= "1000111";
                
                when others => r_hex_encoding <= "0000000"; -- display nothing, allows debugging
            end case;
        end if;
    end process;

    o_segment_a <= r_hex_encoding(6);
    o_segment_b <= r_hex_encoding(5);
    o_segment_c <= r_hex_encoding(4);
    o_segment_d <= r_hex_encoding(3);
    o_segment_e <= r_hex_encoding(2);
    o_segment_f <= r_hex_encoding(1);
    o_segment_g <= r_hex_encoding(0);
end architecture segmented_display_RTL;
