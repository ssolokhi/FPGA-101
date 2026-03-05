module game #(parameter c_MAX_SCORE = 10, parameter c_CYCLES_PER_SECOND = 100000000) (
    input i_clock,
    input i_button_1,
    input i_button_2,
    output reg [3:0] o_score,
    output o_LED_1,
    output o_LED_2
    );
    // Define states
    localparam START = 3'd0;
    localparam PATTERN_ON= 3'd1; // turn on 1 LED to display part of pattern
    localparam PATTERN_OFF = 3'd2; // wait for a timer driven by r_toggle, w_toggle
    localparam AWAIT_PLAYER = 3'd3;
    localparam INCREASE_SCORE = 3'd4;
    localparam WINNER = 3'd5;
    localparam LOSER = 3'd6;
    reg [2:0] r_current_state;

    reg [$clog2(c_MAX_SCORE)-1:0] r_index;
    reg [9:0] r_pattern;
    reg r_button_id; // 0 for button 1, 1 for button 2
    reg r_button_released;
    reg r_toggle;
    reg r_button_1, r_button_2;
    wire [9:0] w_lfsr_generated_pattern;
    wire w_toggle;
    wire w_enable_counter;

    always @(posedge i_clock)
    begin
        if (i_button_1 & i_button_2) r_current_state <= START; // reset from any state
        else 
        begin // main switch of FSM
            case (r_current_state)
                START:
                begin
                    if (!i_button_1 & !i_button_2 & r_button_released)
                    begin
                        o_score <= 0;
                        r_index <= 0;
                        r_current_state <= PATTERN_OFF;
                    end
                end
                PATTERN_OFF:
                begin
                    if (!w_toggle & r_toggle) r_current_state <= PATTERN_ON; // look for falling edge == timer
                end
                PATTERN_ON:
                begin
                    if (!w_toggle & r_toggle) // look for falling edge == timer
                        if (o_score == r_index)
                        begin // reset index and wait for player's input
                            r_index <= 0;
                            r_current_state <= AWAIT_PLAYER;
                        end
                        else
                        begin // increase index and get ready to light up next LED in pattern
                            r_index <= r_index + 1;
                            r_current_state <= PATTERN_OFF;
                        end
                end
                AWAIT_PLAYER:
                begin
                    if (r_button_released)
                        if (r_pattern[r_index] == r_button_id && r_index == o_score) // at the end of the pattern
                        begin
                            r_index <= 0;
                            r_current_state <= INCREASE_SCORE;
                        end
                        else if (r_pattern[r_index] != r_button_id) r_current_state <= LOSER;
                        else r_index <= r_index + 1; // move on to next button press in pattern
                end
                INCREASE_SCORE: // moved out of AWAIT_PLAYER to reduce code complexity with if statements
                begin
                    o_score <= o_score + 1;
                    if (o_score == c_MAX_SCORE - 1) r_current_state <= WINNER;
                    else r_current_state <= PATTERN_OFF; // this will continue the memory sequence
                end
                WINNER: // exit condition is reset
                begin
                    o_score <= 4'hA; // A will represent a win
                end
                LOSER: // exit condition is reset
                begin
                    o_score <= 4'hF; // F for FAIL
                end
                default: // fail-safe: will handle all other states
                    r_current_state <= START;
            endcase
        end
    end


    always @(posedge i_clock)
    begin
        r_toggle <= w_toggle; // creates a delay of 1 clock cycle
        r_button_1 <= i_button_1;
        r_button_2 <= i_button_2;
        if (r_button_1 & !i_button_1) // first button was released
        begin
            r_button_released <= 1'b1;
            r_button_id <= 0;
        end
        else if (r_button_2 & !i_button_2) // second button was released
        begin
            r_button_released <= 1'b1;
            r_button_id <= 1;
        end
        else // no button was pressed
        begin
            r_button_released <= 1'b0;
            r_button_id <= 0;
        end
    end

    always @(posedge i_clock)
    begin
        if (r_current_state == START) 
        begin
            r_pattern[0] <= w_lfsr_generated_pattern[0];
            r_pattern[1] <= w_lfsr_generated_pattern[1];
            r_pattern[2] <= w_lfsr_generated_pattern[2];
            r_pattern[3] <= w_lfsr_generated_pattern[3];
            r_pattern[4] <= w_lfsr_generated_pattern[4];
            r_pattern[5] <= w_lfsr_generated_pattern[5];
            r_pattern[6] <= w_lfsr_generated_pattern[6];
            r_pattern[7] <= w_lfsr_generated_pattern[7];
            r_pattern[8] <= w_lfsr_generated_pattern[8];
            r_pattern[9] <= w_lfsr_generated_pattern[9];
        end
    end

    assign w_enable_counter = (r_current_state == PATTERN_ON || r_current_state == PATTERN_OFF);

    wait_and_toggle #(.c_N_CYCLES_TO_WAIT(c_CYCLES_PER_SECOND/5)) counter_inst (
        .i_clock(i_clock),
        .i_enable_counter(w_enable_counter),
        .o_toggle(w_toggle)
        );
    
    lfsr #(.c_LFSR_BITS(10)) generate_pattern (
        .i_clock(i_clock),
        .o_data(w_lfsr_generated_pattern),
        .o_done()
    );

    // when pattern is shown, an LED will light up per bit in generated patter
    // when getting user's input, the LED corresponding to the pushed button
    // will light up as visual aid
    assign o_LED_1 = (r_current_state == PATTERN_ON && r_pattern[r_index] == 1'b0) ? 1'b1 : i_button_1;
    assign o_LED_2 = (r_current_state == PATTERN_ON && r_pattern[r_index] == 1'b1) ? 1'b1 : i_button_2;
endmodule
