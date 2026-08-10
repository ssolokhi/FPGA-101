`default_nettype none

module toggle_LED(
    input logic i_clock,
    input logic i_reset,
    input logic i_raw_button,
    output logic o_toggle_LED);

    logic r_toggle_LED;
    logic r_button;
    logic w_filtered_button;

    debounce_button #( .c_DEBOUNCE_LIMIT(100000)) u_debounce_button (
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_button_raw(i_raw_button),
        .o_button_debounced(w_filtered_button));
    
    always_ff @(posedge i_clock)
    begin
        if (i_reset)
        begin
            r_button <= 1'b0;
            r_toggle_LED <= 1'b0;
        end
        else
        begin
        // all <= assignments here occur here SIMULTANEOUSLY at the rising edge of the clock
        // therefore, their order of appearance doesn't matter

        r_button <= w_filtered_button; // create a D flip-flop with w_filtered_button as input & r_button as output

        // a flip-flop's output is only changed at a rising edge of a clock, so there is access to
        // the last registered value which can be used below, because the signal needs time to 
        // propagate through the flip-flop's electronic components:

        // not always false, contrast to expectation
        if (w_filtered_button == 1'b0 && r_button == 1'b1) r_toggle_LED <= ~r_toggle_LED;// invert the LED signal by creating a second D flip-flop
        end
    end
    assign o_toggle_LED = r_toggle_LED;
endmodule
