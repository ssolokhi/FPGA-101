module debounce_button #(parameter c_DEBOUNCE_LIMIT = 100) (
    input i_clock,
    input i_button_raw,
    output o_button_debounced);

    reg [$clog2(c_DEBOUNCE_LIMIT) - 1:0] r_counter = 0;
    reg r_current_state = 1'b0;

    always @(posedge i_clock)
    begin
        if (i_button_raw != r_current_state && r_counter < c_DEBOUNCE_LIMIT - 1)
        begin
            r_counter <= r_counter + 1; //wait for a given amount of clock cycles == time
        end
        else if (r_counter == c_DEBOUNCE_LIMIT - 1)
        begin
            r_current_state <= i_button_raw; // time is up, debouncing assumed to be complete
            r_counter <= 0; // reset counter to prevent overflow
        end
        else // in case input == output, simply reset the counter to prepare for next execution
        begin
            r_counter <= 0;
        end
    end
    assign o_button_debounced = r_current_state;
endmodule
