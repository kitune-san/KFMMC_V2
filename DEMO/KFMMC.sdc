create_clock -name CLOCK2_50 -period 20.000 [get_ports {CLK}]
create_clock -name VCLK_SDIO -period 40.000
create_clock -name CLK_25MHZ -period 40.000

derive_pll_clocks
derive_clock_uncertainty

set_input_delay -clock {CLK_25MHZ} -max 10 [all_inputs]
set_input_delay -clock {CLK_25MHZ} -min 5 [all_inputs]
set_output_delay -clock {CLK_25MHZ} -max 10 [all_outputs]
set_output_delay -clock {CLK_25MHZ} -min 5 [all_outputs]

set_input_delay -clock { VCLK_SDIO } -max 10 [get_ports { SD_DATA[*] SD_CMD }]
set_input_delay -clock { VCLK_SDIO } -min 5 [get_ports { SD_DATA[*] SD_CMD }]
set_output_delay -clock { VCLK_SDIO } -max 5 [get_ports { SD_DATA[*] SD_CMD SD_CLK }]
set_output_delay -clock { VCLK_SDIO } -min 0 [get_ports { SD_DATA[*] SD_CMD SD_CLK }]
