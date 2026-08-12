`default_nettype none

module and_gate
    (input logic input_1,
     input logic input_2,
     output logic and_result);
    
    assign and_result = input_1 & input_2;
endmodule
