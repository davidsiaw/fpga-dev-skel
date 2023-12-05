// Modules to provide a 33.3 MHz clock

`ifdef GOWIN_GW1NR_9_CHIP
module Clk_33_3MHZ
(
  input in_clk_27mhz,
  output out_clk_199_8mhz,
  output out_clk_33_3mhz,
  output out_clk_lock
);

rPLL #( // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
  .FCLKIN("27"),
  .IDIV_SEL(4), // -> PFD = 5.4 MHz (range: 3-400 MHz)
  .FBDIV_SEL(36), // -> CLKOUT = 199.8 MHz (range: 3.125-600 MHz)
  .DYN_SDIV_SEL(6),
  .ODIV_SEL(4) // -> VCO = 799.2 MHz (range: 400-1200 MHz)
) pll (.CLKOUTP(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0),
  .CLKIN(in_clk_27mhz), // 27 MHz
  .CLKOUT(out_clk_199_8mhz), // 199.8 MHz
  .CLKOUTD(out_clk_33_3mhz), // 33.300000000000004 MHz
  .LOCK(out_clk_lock)
);

endmodule

module Clk_9MHZ
(
  input in_clk_27mhz,
  output out_clk_540mhz,
  output out_clk_9mhz,
  output out_clk_lock
);

rPLL #( // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
  .FCLKIN("27"),
  .IDIV_SEL(0), // -> PFD = 27 MHz (range: 3-400 MHz)
  .FBDIV_SEL(19), // -> CLKOUT = 540 MHz (range: 3.125-600 MHz)
  .DYN_SDIV_SEL(60),
  .ODIV_SEL(2) // -> VCO = 1080 MHz (range: 400-1200 MHz)
) pll (.CLKOUTP(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0),
  .CLKIN(in_clk_27mhz), // 27 MHz
  .CLKOUT(out_clk_540mhz), // 540 MHz
  .CLKOUTD(out_clk_9mhz), // 9 MHz
  .LOCK(out_clk_lock)
);

endmodule

`endif // GOWIN_GW1NR_9_CHIP

`ifdef GOWIN_GW1NSR_4_CHIP

// TODO make for tangnano4k

`endif // GOWIN_GW1NSR_4_CHIP
