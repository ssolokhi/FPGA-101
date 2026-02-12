module lfsr_tb ();
    reg r_tb_clock = 1'b0;
    always #5 r_tb_clock <= !r_tb_clock;

    reg r_LFSR_done = 1'b0;
    wire w_LFSR_done; // not a register because it simply connects 2 modules

    lfsr #(.c_LFSR_BITS(3)) UUT (
        .i_clock(r_tb_clock),
        .o_done(w_LFSR_done)
        );
        
    always @(posedge r_tb_clock)
    begin
        if (w_LFSR_done) r_LFSR_done <= !r_LFSR_done;
    end
       
       
    initial begin
    assert (r_LFSR_done == 1'b0); // initial condition
    #80;  
    assert (r_LFSR_done == 1'b0);
    #80;  
    assert (r_LFSR_done == 1'b1);

    end
endmodule
