module wait_and_toggle #(parameter c_N_CYCLES_TO_WAIT = 100000) (
    input i_clock,
    input i_enable_counter,
    output reg o_toggle
    );
   
    reg [$clog2(c_N_CYCLES_TO_WAIT-1):0] r_counter;
    always @(posedge i_clock)
    begin
        if (i_enable_counter == 1'b1)
        begin
            if (r_counter == c_N_CYCLES_TO_WAIT - 1)
            begin
                o_toggle <= !o_toggle;
                r_counter <= 0;
            end
            else r_counter <= r_counter + 1;
        end
        else o_toggle <= 1'b0;
    end
endmodule
