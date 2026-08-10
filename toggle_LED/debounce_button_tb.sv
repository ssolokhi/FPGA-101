`default_nettype none

module debounce_button_tb ();
    logic r_tb_clock = 1'b0;
    logic r_tb_reset = 1'b0;
    logic r_tb_button_raw = 1'b0;
    logic r_tb_button_debounced;
    // this signal will invert every 5 ns, thus mimicking a clock with a period of 10 ns, duty cycle 50%
    // this matches the clock period in the constraints file
    always #5 r_tb_clock <= !r_tb_clock;

    // assign a small number of clock cycles to the debounce limit for a quicker simulation
    localparam int c_TB_DEBOUNCE_LIMIT = 5;
    debounce_button #( .c_DEBOUNCE_LIMIT(c_TB_DEBOUNCE_LIMIT)) UUT (
        .i_clock(r_tb_clock),
        .i_reset(r_tb_reset),
        .i_button_raw(r_tb_button_raw),
        .o_button_debounced(r_tb_button_debounced));

    // assertion that runs continuously
    property p_debounce_works_correctly;
        @(posedge r_tb_clock) disable iff (r_tb_reset) // stop the assertion if reset is high
        // $stable = should not have rising\falling edge 
        // X [*N] = X must be logic-high N times one after another
        // $past to account for 1 clock cycle delay UUT
        $stable(r_tb_button_raw) [*c_TB_DEBOUNCE_LIMIT] |=> (r_tb_button_debounced == $past(r_tb_button_raw)); 
    endproperty

    // name a_debounce_works_correctly will be traceable in simulation when assertion fails
    a_debounce_works_correctly: assert property (p_debounce_works_correctly) 
    else $error("%0t: Debounce doesn't work correctly: expected 0, got %b", $time, r_tb_button_debounced);

    initial begin
        // check how reset works first 
        r_tb_reset <= 1'b1;
        repeat(2) @(posedge r_tb_clock);
        r_tb_reset <= 1'b0;

        @(posedge r_tb_clock); // wait after reset released

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

        r_tb_reset <= 1'b1;
        @(posedge r_tb_clock);
        if (r_tb_button_debounced !== 1'b0) // x and x will give 1; not synthesizable
            $error("%0t: Reset did not clear r_tb_button_debounced: expected 0, got %b", $time, r_tb_button_debounced);
        r_tb_reset <= 1'b0;

        repeat(2) @(posedge tb_clock); 
        $display("%0t: Simulation finished", $time);
        $finish;
    end

    // In case the UUT hangs and never reaches $finish
    initial begin
        #1000;
        $display("ERROR: testbench timeout");
        $finish; // first $finish to execute finished the testbench - this one or the one above => fail-safe
    end
endmodule
