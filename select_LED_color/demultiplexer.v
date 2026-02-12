module demultiplexer (
    input i_drive_LED,
    input i_select_1,
    input i_select_2,
    output o_LED_blue,
    output o_LED_green,
    output o_LED_red
    );

assign o_LED_blue = i_select_1 & !i_select_2 ? i_drive_LED : 1'b0;
assign o_LED_green = !i_select_1 & i_select_2 ? i_drive_LED : 1'b0;
assign o_LED_red = i_select_1 & i_select_2 ? i_drive_LED : 1'b0;

endmodule
