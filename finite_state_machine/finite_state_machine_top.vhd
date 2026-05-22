library ieee;
use ieee.std_logic_1164.all;

entity finite_state_machine_top is
    port (
        i_clock: in std_logic;
        i_raw_button_1: in std_logic;
        i_raw_button_2: in std_logic;
        o_LED_1: out std_logic;
        o_LED_2: out std_logic;
        o_display_segment_a: out std_logic;    
        o_display_segment_b: out std_logic;    
        o_display_segment_c: out std_logic;    
        o_display_segment_d: out std_logic;    
        o_display_segment_e: out std_logic;    
        o_display_segment_f: out std_logic;    
        o_display_segment_g: out std_logic);
end entity finite_state_machine_top;

architecture finite_state_machine_top_RTL of finite_state_machine_top is
    constant c_DEBOUNCE_LIMIT: integer := 100000;
    signal w_button_1: std_logic;
    signal w_button_2: std_logic;
    constant c_MAX_SCORE: integer := 8;
    signal w_score: std_logic_vector(3 downto 0);
begin
    debounce_button_1: entity work.debounce_button 
    generic map (
        c_DEBOUNCE_LIMIT => c_DEBOUNCE_LIMIT)
    port map (
        i_clock => i_clock,
        i_raw_button => i_raw_button_1,
        o_debounced_button => w_button_1);
    debounce_button_2: entity work.debounce_button 
    generic map (
        c_DEBOUNCE_LIMIT => c_DEBOUNCE_LIMIT)
    port map (
        i_clock => i_clock,
        i_raw_button => i_raw_button_2,
        o_debounced_button => w_button_2);

    game_inst: entity work.game 
    generic map (
        c_MAX_SCORE => c_MAX_SCORE)
    port map (
        i_clock => i_clock,
        i_button_1 => w_button_1,
        i_button_2 => w_button_2,
        o_score => w_score,
        o_LED_1 => o_LED_1,
        o_LED_2 => o_LED_2);

    show_score: entity work.segmented_display
    port map (
        i_clock => i_clock,
        i_binary_to_display => w_score,
        o_segment_a => o_display_segment_a,        
        o_segment_b => o_display_segment_b,        
        o_segment_c => o_display_segment_c,        
        o_segment_d => o_display_segment_d,        
        o_segment_e => o_display_segment_e,        
        o_segment_f => o_display_segment_f,        
        o_segment_g => o_display_segment_g);
end finite_state_machine_top_RTL;
