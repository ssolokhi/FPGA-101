module select_LED_color_tb ();
    reg r_tb_clock = 1'b0;
    always #5 r_tb_clock <= !r_tb_clock;

    reg r_select_1 = 1'b0;
    reg r_select_2 = 1'b0;
    wire r_LED_blue;
    wire r_LED_green;
    wire r_LED_red;
    reg r_LFSR_done = 1'b0;
    wire w_LFSR_done; // not a register because it simply connects 2 modules

    lfsr #(.c_LFSR_BITS(3)) lfsr_UUT (
        .i_clock(r_tb_clock),
        .o_done(w_LFSR_done)
        );
    
    always @(posedge r_tb_clock)
    begin
        if (w_LFSR_done) r_LFSR_done <= !r_LFSR_done;
    end

    demultiplexer demux_UUT (
        .i_drive_LED(r_LFSR_done),
        .i_select_1(r_select_1),
        .i_select_2(r_select_2),
        .o_LED_blue(w_LED_blue),
        .o_LED_green(w_LED_green),
        .o_LED_red(w_LED_red)
        );
    initial begin
        #250;
        r_select_1 <= 1'b1;
        r_select_2 <= 1'b0;
        #250; 
        r_select_1 <= 1'b0;
        r_select_2 <= 1'b1;
        #250;
        r_select_1 <= 1'b1;
        r_select_1 <= 1'b1;
        #250;
    end
endmodule
