module select_LED_color (
    input i_clock,    
    input i_button_1,
    input i_button_2,
    output o_LED_blue,
    output o_LED_green,
    output o_LED_red
    );

    reg r_LFSR_done = 1'b0;
    wire w_LFSR_done; // not a register because it simply connects 2 modules

    lfsr #(.c_LFSR_BITS(25)) lfsr_25_bit (
        .i_clock(i_clock),
        .o_done(w_LFSR_done)
        );
    
    always @(posedge i_clock)
    begin
        if (w_LFSR_done) r_LFSR_done <= !r_LFSR_done;
    end

    demultiplexer demux_inst (
        .i_drive_LED(r_LFSR_done),
        .i_select_1(i_button_1),
        .i_select_2(i_button_2),
        .o_LED_blue(o_LED_blue),
        .o_LED_green(o_LED_green),
        .o_LED_red(o_LED_red)
        );
endmodule
