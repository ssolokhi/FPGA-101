`default_nettype none

module debounce_button #(parameter c_DEBOUNCE_LIMIT = 100) (
    input logic i_clock,
    input logic i_reset,
    input logic i_button_raw,
    output logic o_button_debounced);

    logic [$clog2(c_DEBOUNCE_LIMIT) - 1:0] r_counter;
    logic r_current_state;

    always_ff @(posedge i_clock)
    begin
        if (i_reset)
        begin
            r_counter <= '0;
            r_current_state <= 1'b0; 
        end
        else if (i_button_raw != r_current_state && r_counter < c_DEBOUNCE_LIMIT - 1)
        begin
            r_counter <= r_counter + 1; //wait for a given amount of clock cycles == time
        end
        else if (r_counter == c_DEBOUNCE_LIMIT - 1)
        begin
            r_current_state <= i_button_raw; // time is up, debouncing assumed to be complete
            r_counter <= '0; // reset r_counter to prevent overflow
        end
        else // in case input == output, simply reset the r_counter to prepare for next execution
        begin
            r_counter <= '0;
        end
    end
    assign o_button_debounced = r_current_state;
endmodule
