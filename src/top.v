module top
(
    input        clk_27mhz,
    input        rst_btn,
    output [5:0] led,

    output       lcd_en,
    output       lcd_hsync,
    output       lcd_vsync,

    output [4:0] lcd_b,
    output [5:0] lcd_g,
    output [4:0] lcd_r,

    output       lcd_clk,
    output       lcd_led_en
);

//assign led = ~6'b011000;

wire fclk;
wire clk_lock;
wire clk_9mhz;

reg reset = 1;


reg [31:0] resetcounter = 0;

always @(posedge clk_27mhz) begin
  if (resetcounter <= 27000000 * 2) begin
    reset <= 1;
    resetcounter <= resetcounter + 1;
  end
  else if (rst_btn == 0) begin
    reset <= 1;
    resetcounter <= 0;
  end
  else begin
    resetcounter <= resetcounter;
    reset <= 0;
  end

end

assign lcd_led_en = 1;

//assign reset = ~rst_btn | ~clk_lock;

// Clk_33_3MHZ pll(
//   .in_clk_27mhz(clk_27mhz),
//   .out_clk_199_8mhz(fclk),
//   .out_clk_33_3mhz(clk_33_3mhz),
//   .out_clk_lock(clk_lock)
// );

rPLL #( // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
  .FCLKIN("27"),
  .IDIV_SEL(2), // -> PFD = 9 MHz (range: 3-400 MHz)
  .FBDIV_SEL(9), // -> CLKOUT = 90 MHz (range: 3.125-600 MHz)
  .DYN_SDIV_SEL(10),
  .ODIV_SEL(8) // -> VCO = 720 MHz (range: 400-1200 MHz)
) pll (.CLKOUTP(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0),
  .CLKIN(clk_27mhz), // 27 MHz
  .CLKOUT(fclk), // 90 MHz
  .CLKOUTD(clk_9mhz), // 9 MHz
  .LOCK(clk_lock)
);

wire [9:0] pixelx;
wire [9:0] pixely;

wire ssync;

TftLcd_480_272 lcd(
    .in_rst(reset),
    .in_9mhz_clk(clk_9mhz & clk_lock),

    .out_en(lcd_en),
    .out_hsync(lcd_hsync),
    .out_vsync(lcd_vsync),
    .out_ssync(ssync),

    .out_pixelx(pixelx),
    .out_pixely(pixely),
    .out_clk(lcd_clk)
);


LedCounter #(
    .WAIT_TIME(1)
  )
c (
  .in_rst(reset),
  .in_clk(ssync),
  .out_led(led)
);

assign lcd_r = (pixely[3] ^ pixelx[3]) ? 5'b11111 : 0;
assign lcd_g = (pixely[4] ^ pixelx[4]) ? 6'b111111 : 0;;
assign lcd_b = (pixely[5] ^ pixelx[5]) ? 5'b11111 : 0;;

endmodule
