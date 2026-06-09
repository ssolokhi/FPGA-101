module math_operations_tb();
    reg unsigned [3:0] i1_u4, i2_u4, o_u4;
    reg signed [3:0] i1_s4, i2_s4, o_s4;
    reg unsigned [4:0] o_u5;
    reg signed [4:0] i1_s5, i2_s5, o_s5;
    
    reg unsigned [5:0] o_u6;
    reg unsigned [7:0] i1_u8, o_u8;
    reg signed [7:0] o_s8;
    initial begin
        // adding two unsigned numbers incorrectly
        i1_u4 = 4'b1001;
        i2_u4 = 4'b1011;
        o_u4 = i1_u4 + i2_u4;
        $display("Added %2d + %2d =/= %3d", i1_u4, i2_u4, o_u4);
        // adding two signed numbers incorrectly
        i1_s4 = 4'b1001;
        i2_s4 = 4'b1011;
        o_s4 = i1_s4 + i2_s4;
        $display("Added %2d + %2d =/= %3d", i1_s4, i2_s4, o_s4);
        // adding two unsigned numbers correctly
        i1_u4 = 4'b1001;
        i2_u4 = 4'b1011;
        o_u4 = i1_u4 + i2_u4;
        $display("Added %2d + %2d = %3d", i1_u4, i2_u4, o_u5);
        // adding two signed numbers correctly
        i1_s4 = 4'b1001;
        i2_s4 = 4'b1011;
        o_s5 = i1_s4 + i2_s4;
        $display("Added %2d + %2d = %3d", i1_s4, i2_s4, o_s5);

        // subtracting two unsigned numbers incorrectly
        i1_u4 = 4'b1001;
        i2_u4 = 4'b1011;
        o_u5 = i1_u4 - i2_u4;
        $display("Subtracted %2d - %2d =/= %3d", i1_u4, i2_u4, o_u5);
        // subtracting two signed numbers correctly
        i1_u4 = 4'b1001;
        i2_u4 = 4'b1011;
        i1_s5 = i1_u4; // type conversion performed automatically
        i2_s5 = i2_u4;
        o_s4 = i1_s5 - i2_s5;
        $display("Subtracted %2d - %2d = %3d", i1_s5, i2_s5, o_s5);

        // multiplying two unsigned numbers
        i1_u4 = 4'b1001;
        i2_u4 = 4'b1011;
        o_u8 = i1_u4 * i2_u4;
        $display("Multiplied %2d * %2d = %3d", i1_u4, i2_u4, o_u8);
        // multiplying two signed numbers 
        i1_s4 = 4'b1001;
        i2_s4 = 4'b1011;
        o_s8 = i1_s4 * i2_s4;
        $display("Multiplied %2d * %2d = %3d", i1_s4, i2_s4, o_s8);

        // multiplication using bit shifts
        i1_u8 = 3;
        o_u8 = i1_u8 << 1;
        $display("Bit-shifted to the left %2d * 2 = %3d", i1_u8, o_u8);
        o_u8 = i1_u8 << 2;
        $display("Bit-shifted to the left %2d * 4 = %3d", i1_u8, o_u8);
        o_u8 = i1_u8 << 3;
        $display("Bit-shifted to the left %2d * 8 = %3d", i1_u8, o_u8);

        // division using bit shifts
        i1_u8 = 12;
        o_u8 = i1_u8 >> 1;
        $display("Bit-shifted to the right %2d / 2 = %3d", i1_u8, o_u8);
        o_u8 = i1_u8 >> 2;
        $display("Bit-shifted to the right %2d / 4 = %3d", i1_u8, o_u8);
        o_u8 = i1_u8 >> 3;
        $display("Bit-shifted to the right %2d / 8 = %3d (result rounded down)", i1_u8, o_u8);

        // adding two floating-point numbers incorrectly
        i1_u4 = 4'b1001; // Q3.1
        i2_u4 = 4'b1011; // Q4.0
        o_u5 = i1_u4 + i2_u4;
        $display("Added floating-point numbers %2.3f + %2.3f =/= %2.3f", i1_u4, i2_u4, o_u5/2.0); // divide by 2^1 = 2, see README
        // adding two floating-point numbers correctly
        i1_u4 = 4'b1001; // Q3.1
        i2_u4 = 4'b1011; // Q4.0
        i1_u5 = i1_u4 << 1; // convert Q3.1 to Q4.
        o_u6 = i1_s4 + i2_u5;
        $display("Added floating-point-numbers %2d + %2d = %3d", i1_u4/2.0, i2_u5/2.0, o_u6/2.0);

        // multiplying two floating-point numbers
        i1_u4 = 4'b1001; // Q2.2
        i2_u4 = 4'b1011; // 3.1
        // multiplication result will be Q5.3 => 8 bits wide
        o_u8 = i1_u4 * i2_u4;
        $display("Multiplyed floating-point-numbers %2.3f * %2.3f = %2.3f", i1_u4/4.0, i2_u5/2.0, o_u6/8.0);
    $finish();    
    end
endmodule
