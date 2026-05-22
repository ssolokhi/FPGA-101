library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    generic (
        c_MAX_SCORE: integer := 5;       
        c_CYCLES_PER_SECOND: integer := 100000000
    );
    port (
        i_clock: in std_logic;
        i_button_1: in std_logic;
        i_button_2: in std_logic;
        o_score: out std_logic_vector(3 downto 0);
        o_LED_1: out std_logic;
        o_LED_2: out std_logic
         );
end entity game;

architecture game_RTL of game is
    type t_state is (START, PATTERN_ON, PATTERN_OFF, AWAIT_PLAYER, INCREASE_SCORE, WINNER, LOSER);
    signal r_current_state: t_state;
 
    signal r_score: unsigned(3 downto 0);   
    signal r_index: integer range 0 to c_MAX_SCORE;
    signal w_index: std_logic_vector(7 downto 0);
    signal r_pattern: std_logic_vector(9 downto 0);
    signal r_button_id: std_logic; -- 0 for button 1, 1 for button 2
    signal r_button_released: std_logic; 
    signal r_toggle, w_toggle: std_logic;
    signal r_button_1, r_button_2: std_logic;
    signal w_lfsr_generated_pattern: std_logic_vector(9 downto 0);
    signal w_enable_counter: std_logic;

begin
    process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if i_button_1 = '1' and i_button_2 = '1' then
                r_current_state <= START;
            else
                case r_current_state is
                    when START =>
                        if (i_button_1 = '0' and i_button_2 = '0' and r_button_released = '1') then
                            r_score <= to_unsigned(0, r_score'length);
                            r_index <= 0;
                            r_current_state <= PATTERN_OFF;
                        end if;
                    when PATTERN_OFF => 
                        if w_toggle = '0' and r_toggle = '1' then -- looking for falling edge == timer
                            r_current_state <= PATTERN_ON;
                        end if;
                    when PATTERN_ON =>
                        if w_toggle = '0' and r_toggle ='1' then -- looking for falling edge == timer
                            if r_score = r_index then
                                r_index <= 0;
                                r_current_state <= AWAIT_PLAYER;
                            else
                                r_index <= r_index + 1;
                                r_current_state <= PATTERN_OFF; -- prepare to light up next LED in pattern after a pause
                            end if;
                        end if;
                    when AWAIT_PLAYER =>
                        if r_button_released = '1' then 
                            if (r_pattern(r_index) = r_button_id and unsigned(w_index) = r_score) then -- end of the pattern
                                r_index <= 0;
                                r_current_state <= INCREASE_SCORE;
                            elsif r_pattern(r_index) /= r_button_id then
                                r_current_state <= LOSER;
                            else
                                r_index <= r_index + 1;
                            end if;
                        end if;
                    when INCREASE_SCORE =>
                        r_score <= r_score + 1;
                        if r_score = c_MAX_SCORE then
                            r_current_state <= WINNER;
                        else
                            r_current_state <= PATTERN_OFF;
                        end if;
                    when WINNER =>  -- exit condition is reset
                        r_score <= X"A";
                    when LOSER =>
                        r_score <= X"F"; -- exit condition is reset
                    when others => -- fail-safe
                        r_current_state <= START;
                end case;
            end if;
        end if;
    end process;

    -- look for button releases
    process(i_clock) is 
    begin 
        if rising_edge(i_clock) then 
            r_toggle <= w_toggle; -- creates a delay of 1 clock cycle
            r_button_1 <= i_button_1;
            r_button_2 <= i_button_2;
            if r_button_1 = '1' and i_button_1 = '0' then
                r_button_released <= '1';
                r_button_id <= '0';
            elsif r_button_2 = '1' and i_button_2 = '0' then
                r_button_released <= '1';
                r_button_id <= '1';
            else -- no button was pressed
                r_button_released <= '0';
                r_button_id <= '0';
            end if;
        end if;
    end process;
    
    process (i_clock) is 
    begin
        if rising_edge(i_clock) then 
            if r_current_state = START then
                r_pattern <= w_lfsr_generated_pattern;
            end if;
        end if;
    end process;
    w_index <= std_logic_vector(to_unsigned(r_index, w_index'length)); -- convert r_index to vector representation due to strong typing

    w_enable_counter <= '1' when (r_current_state = PATTERN_ON or r_current_state = PATTERN_OFF) else '0';

    counter_inst: entity work.wait_and_toggle
    generic map(
        c_N_CYCLES_TO_WAIT => c_CYCLES_PER_SECOND/5)
    port map (
        i_clock => i_clock,
        i_enable_counter => w_enable_counter,
        o_toggle => w_toggle);

    generate_pattern: entity work.lfsr
    generic map(
        c_LFSR_BITS => 10)
    port map (
        i_clock => i_clock,
        o_data => w_lfsr_generated_pattern,
        o_done => open);
    o_score <= std_logic_vector(r_score);

    -- when pattern is shown, an LED will light up per bit in generated patter
    -- when getting user's input, the LED corresponding to the pushed button
    -- will light up as visual aid
    o_LED_1 <= '1' when (r_current_state = PATTERN_ON and r_pattern(r_index) = '0') else i_button_1;
    o_LED_2 <= '1' when (r_current_state = PATTERN_ON and r_pattern(r_index) = '1') else i_button_2;
end architecture game_RTL;
