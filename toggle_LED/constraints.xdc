## PL System Clock
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports {i_clock }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { i_clock }];

## blue LED
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { o_toggle_LED }];

## Button
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { i_raw_button }];
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { i_reset }]; #IO_L4P_T0_35 Sch=btn[1]

