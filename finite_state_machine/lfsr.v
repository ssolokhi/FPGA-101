module lfsr #(parameter c_LFSR_BITS = 10) (
    input i_clock,
    output [c_LFSR_BITS-1:0] o_data,
    output o_done
    );
    reg [c_LFSR_BITS-1:0] r_LFSR;
    wire w_XNOR_gate;
    
    always @(posedge i_clock)
    begin
       r_LFSR <= {r_LFSR[c_LFSR_BITS-2:0], w_XNOR_gate}; // concatenate 2 arrays. another -1 to account for the shift
    end
    assign o_done = (r_LFSR == 'b0);
    assign o_data = r_LFSR;
    assign w_XNOR_gate = r_LFSR[c_LFSR_BITS-1] ^ ~r_LFSR[c_LFSR_BITS-2]; // XNOR(A,B) is equivalent to XOR(A, !B), hence such formula
endmodule
