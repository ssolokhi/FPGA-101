module debounce_button_tb ();
    reg r_tb_clock = 1'b0;
    reg r_tb_button_raw = 1'b0;
    // this signal will invert every 5 ns, thus mimicking a clock with a period of 10 ns, duty cycle 50%
    // this matches the clock period in the constraints file
    always #5 r_tb_clock <= !r_tb_clock;

    // assign a small number of clock cycles to the debounce limit for a quicker simulation
    debounce_button #( .c_DEBOUNCE_LIMIT(5)) UUT (
        .i_clock(r_tb_clock),
        .i_button_raw(r_tb_button_raw),
        .o_button_debounced(w_tb_button_debounced));

    initial begin
        repeat(3) @(posedge r_tb_clock);
        r_tb_button_raw <= 1'b1;
        
        @(posedge r_tb_clock);
        r_tb_button_raw <= 1'b0; // simulate a first bounce for 1 clock cycle

        @(posedge r_tb_clock);
        r_tb_button_raw <= 1'b1; // first bounce phase is finished
        
        repeat(3) @(posedge r_tb_clock);
        r_tb_button_raw <= 1'b0; // simulate another bounce for 3 clock cycles - there should still be no output

        @(posedge r_tb_clock);
        r_tb_button_raw <= 1'b1; // bouncing is finished globally
    
        repeat(6) @(posedge r_tb_clock); // by this time the debounced signal should turn to 1
    end
endmodule
