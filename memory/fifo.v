module FIFO #(parameter c_WIDTH = 16, c_DEPTH = 32, c_ALMOST_FULL_LEVEL = 2, c_ALMOST_EMPTY_LEVEL = 2) (
    input i_write_clock,
    input i_write_enable,
    input [c_WIDTH-1:0] i_write_data,
    input i_read_clock,
    input i_read_enable,
    output reg [c_WIDTH-1:0] o_read_data,
    output reg o_read_ready,
    output o_is_full,
    output o_is_almost_full,
    output o_is_empty,
    output o_is_almost_empty
    );

    reg [c_WIDTH-1:0] r_FIFO [c_DEPTH-1:0]; // declare FIFO as an array of memory
    reg [$clog2(c_DEPTH)-1:0] r_write_address; // will be looped over automatically
    reg [$clog2(c_DEPTH)-1:0] r_read_address; // will be looped over automatically
    reg r_element_count = 'd0; // keep track of number of elements

    always @(posedge i_write_clock)
    begin
        if (i_write_enable) 
        begin
            if (r_write_address == c_DEPTH - 1)
                r_write_address <= 0; // to prevent overflow
            else    
                r_FIFO[r_write_address] <= i_write_data;
                r_write_address <= r_write_address + 1;
        end
        if (i_write_enable & ~i_read_enable)
        begin
            if (r_element_count != 0) r_element_count <= r_element_count + 1;
        end
    end

    always @(posedge i_read_clock)
    begin
        if (i_read_enable)
        begin
            o_read_data <= w_read_data;
            if (r_read_address == c_DEPTH - 1)
                r_read_address <= 0;
            else
                r_read_address <= r_read_address + 1;
        end
        if (i_read_enable & ~i_write_enable)
        begin
            if (r_element_count != 0) r_element_count <= r_element_count - 1;
        end
    end
    assign o_read_ready = i_read_enable;
    assign o_read_data = r_FIFO[r_read_address];
    assign o_is_full = (r_element_count == c_DEPTH) || (r_element_count == c_DEPTH - 1 && i_write_enable && !i_read_enable);
    assign o_is_almost_full = (r_element_count > c_DEPTH - c_ALMOST_FULL_LEVEL);
    assign o_is_empty = (r_element_count == 0);
    assign o_is_almost_empty = (r_element_count < c_ALMOST_EMPTY_LEVEL);
endmodule
