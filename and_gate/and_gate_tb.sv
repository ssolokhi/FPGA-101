`default_nettype none

module and_gate_tb();
    logic r_test_input_1, r_test_input_2;
    logic w_test_output;

    and_gate UUT
    (   
        .input_1(r_test_input_1),
        .input_2(r_test_input_2),
        .and_result(w_test_output)
    );

    localparam time c_WAIT_TIME = 10;
    initial begin// start providing test inputs to the AND gate
        for (int i = 0; i < 4; ++i) begin
            // python-style unpacking on the left is also valid here
            {r_test_input_1, r_test_input_2} = i[1:0]; // i = 00, 01, 10, 11 in this loop => take bits from it
            #c_WAIT_TIME
            a_and_test: assert (w_test_output == (r_test_input_1 && r_test_input_2)) else
            $error("Error in %b & %b: expected %b, got %b", 
            r_test_input_1, r_test_input_2, r_test_input_1 && r_test_input_2, w_test_output);
        end
            $display("%0t: Simulation finished", $time);
            $finish;
        end
endmodule
