module segmented_display(
    input i_clock,
    input [3:0] i_binary_to_display, // 4 bits to hold 16 inputs from 0x0 to 0xF
    output o_segment_a,
    output o_segment_b,
    output o_segment_c,
    output o_segment_d,
    output o_segment_e,
    output o_segment_f,
    output o_segment_g
    );
    reg [6:0] r_hex_encoding; // 7 bits - one for each 

    always @(posedge i_clock)
    begin
        case (i_binary_to_display)
            // encoding A to G goes from most significant bit to least significant
            // to verify correctness, draw the display with correctly mapped
            // ports and see which segments should light up
            4'b0000: r_hex_encoding <= 7'b1111110;
            4'b0001: r_hex_encoding <= 7'b0110000;
            4'b0010: r_hex_encoding <= 7'b1101101;
            4'b0011: r_hex_encoding <= 7'b1111001;

            4'b0100: r_hex_encoding <= 7'b0110011;
            4'b0101: r_hex_encoding <= 7'b1011011;
            4'b0110: r_hex_encoding <= 7'b1011111;
            4'b0111: r_hex_encoding <= 7'b1110000;
            
            4'b1000: r_hex_encoding <= 7'b1111111;
            4'b1001: r_hex_encoding <= 7'b1111011;
            4'b1010: r_hex_encoding <= 7'b1110111;
            4'b1011: r_hex_encoding <= 7'b0011111;
            
            4'b1100: r_hex_encoding <= 7'b1001110;
            4'b1101: r_hex_encoding <= 7'b0111101;
            4'b1110: r_hex_encoding <= 7'b1001111;
            4'b1111: r_hex_encoding <= 7'b1000111;
            
            default: r_hex_encoding <= 7'b0000000; // display nothing, allows debugging
        endcase
    end

    assign o_segment_a = r_hex_encoding[6];
    assign o_segment_b = r_hex_encoding[5];
    assign o_segment_c = r_hex_encoding[4];
    assign o_segment_d = r_hex_encoding[3];
    assign o_segment_e = r_hex_encoding[2];
    assign o_segment_f = r_hex_encoding[1];
    assign o_segment_g = r_hex_encoding[0];
endmodule
