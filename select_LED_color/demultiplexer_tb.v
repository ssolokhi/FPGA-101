module demultiplexer_tb ();
    reg r_done = 1'b0;
    reg r_tb_select_1 = 1'b0;
    reg r_tb_select_2 = 1'b0;  

    demultiplexer UUT (
        .i_drive_LED(r_done),
        .i_select_1(r_tb_select_1),
        .i_select_2(r_tb_select_2),
        .o_LED_blue(o_LED_blue),
        .o_LED_green(o_LED_green),
        .o_LED_red(o_LED_red)
        );

    initial begin
        // first check that outputs are low when no data is sent
        // regardless of switches being turned on
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b0);
        #10;

        r_tb_select_1 <= 1'b0;
        r_tb_select_2 <= 1'b1;
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b0);
        #10;

        r_tb_select_1 <= 1'b1;
        r_tb_select_2 <= 1'b0;
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b0);
        #10;

        r_tb_select_1 <= 1'b1;
        r_tb_select_2 <= 1'b1;
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b0);
        #10;

        r_done <= 1'b1; // now check what happens when data is sent
        r_tb_select_1 <= 1'b0;
        r_tb_select_2 <= 1'b0;
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b0);
        #10;


        r_tb_select_1 <= 1'b0;
        r_tb_select_2 <= 1'b1;
        #1; // to allow the signals to stabilize
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b1);
        assert (o_LED_red == 1'b0);
        #10;


        r_tb_select_1 <= 1'b1;
        r_tb_select_2 <= 1'b0;
        #1;
        assert (o_LED_blue == 1'b1);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b0);
        #10;
        
        r_tb_select_1 <= 1'b1;
        r_tb_select_2 <= 1'b1;
        #1;
        assert (o_LED_blue == 1'b0);
        assert (o_LED_green == 1'b0);
        assert (o_LED_red == 1'b1);
        #10;
    end
endmodule
