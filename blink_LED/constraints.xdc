## PL System Clock
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports {i_clock }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { i_clock }];

## blue LED
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { o_LED_signal }];

## Buttons
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { i_enable_LED }];
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { i_select_frequency }];

