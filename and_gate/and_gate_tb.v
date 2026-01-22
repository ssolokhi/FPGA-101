module and_gate_tb();
    reg r_test_input_1, r_test_input_2;
    wire w_test_output;

    and_gate UUT
    (   
        .input_1(r_test_input_1),
        .input_2(r_test_input_2),
        .and_result(w_test_output)
    );
    initial // start providing test inputs to the AND gate
        begin
            $dumpfile("tb_dump.vcd"); $dumpvars; // required for simulations in EDA Playground
            r_test_input_1 <= 1'b0;
            r_test_input_2 <= 1'b0;
            #10; // wait fot 10 ns. Works only in simulation, real FPGA's don't know what time is
            r_test_input_1 <= 1'b1;
            r_test_input_2 <= 1'b0;
            #10;
            r_test_input_1 <= 1'b0;
            r_test_input_2 <= 1'b1;
            #10;
            r_test_input_1 <= 1'b1;
            r_test_input_2 <= 1'b1;
            #10;
            $finish();
        end
endmodule
