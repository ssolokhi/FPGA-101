module finite_state_machine_top(
    input i_clock,
    input i_raw_button_1,
    input i_raw_button_2,
    output o_LED_1,
    output o_LED_2,
    output o_display_segment_a,
    output o_display_segment_b,
    output o_display_segment_c,
    output o_display_segment_d,
    output o_display_segment_e,
    output o_display_segment_f,
    output o_display_segment_g
    );
    
    localparam c_DEBOUNCE_LIMIT = 1000000;
    wire w_button_1, w_button_2;
    debounce_button #(.c_DEBOUNCE_LIMIT(c_DEBOUNCE_LIMIT)) debounce_button_1(
        .i_clock(i_clock),
        .i_button_raw(i_raw_button_1),
        .o_button_debounced(w_button_1)
    );
    debounce_button #(.c_DEBOUNCE_LIMIT(c_DEBOUNCE_LIMIT)) debounce_button_2(
        .i_clock(i_clock),
        .i_button_raw(i_raw_button_2),
        .o_button_debounced(w_button_2)
    );
    
    wire [3:0] w_score;
    localparam c_MAX_SCORE = 8;
    game #(.c_MAX_SCORE(c_MAX_SCORE)) game_inst (
        .i_clock(i_clock),
        .i_button_1(w_button_1),
        .i_button_2(w_button_2),
        .o_score(w_score),
        .o_LED_1(o_LED_1),
        .o_LED_2(o_LED_2)
    );

    segmented_display show_score(
        .i_clock(i_clock),
        .i_binary_to_display(w_score),
        .o_segment_a(o_display_segment_a),
        .o_segment_b(o_display_segment_b),
        .o_segment_c(o_display_segment_c),
        .o_segment_d(o_display_segment_d),
        .o_segment_e(o_display_segment_e),
        .o_segment_f(o_display_segment_f),
        .o_segment_g(o_display_segment_g)
    );
endmodule
