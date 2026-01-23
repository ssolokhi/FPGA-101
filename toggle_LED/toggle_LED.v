module toggle_LED(
    input i_clock,
    input i_button,
    output o_toggle_LED);

    reg r_toggle_LED = 1'b0;
    reg r_button = 1'b0;
    
    always @(posedge i_clock)
    begin
        // all <= assignments here occur here SIMULTANEOUSLY at the rising edge of the clock
        // therefore, their order of appearance doesn't matter

        r_button <= i_button; // create a D flip-flop with i_button as input & r_button as output

        // a flip-flop's output is only changed at a rising edge of a clock, so there is access to
        // the last registered value which can be used below, because the signal needs time to 
        // propagate through the flip-flop's electronic components:

        if (i_button == 1'b0 && r_button == 1'b1) // not always false, contrast to expectation
        begin 
            r_toggle_LED <= ~r_toggle_LED;// invert the LED signal by creating a second D flip-flop
        end
    end
    assign o_toggle_LED = r_toggle_LED;
endmodule
