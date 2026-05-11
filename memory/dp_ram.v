module dual_port_RAM #(parameter c_WIDTH = 16, c_DEPTH = 32) (
    input i_write_clock,
    input [$clog2(c_DEPTH)-1:0] i_write_address,
    input i_write_enable,
    input [c_WIDTH-1:0] i_write_data,
    input i_read_clock,
    input [$clog2(c_DEPTH)-1:0] i_read_address,
    input i_read_enable,
    output reg [c_WIDTH-1:0] o_read_data,
    output reg o_read_ready
    );

    reg [c_WIDTH-1:0] r_RAM [c_DEPTH-1:0]; // define a RAM block of size c_WIDTH x c_DEPTH
    // the $clog2() is not used for c_DEPTH because it's the physical memory depth, 
    // not the address (which is encoded in binary => logarithm is needed)

    always @(posedge i_write_clock)
    begin
        if (i_write_enable) r_RAM[i_write_address] <= i_write_data;
    end

    always @(posedge i_read_clock)
    begin
        if (i_read_enable) o_read_data <= r_RAM[i_read_address];
        o_read_ready <= i_read_enable;
    end
endmodule
