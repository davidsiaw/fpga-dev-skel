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

    output       lcd_clk
);

//assign led = ~6'b011000;

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

wire fclk;
wire clk_lock;
wire clk;

Clk_9MHZ clk9(
  .in_clk_27mhz(clk_27mhz),
  .out_clk_90mhz(fclk),
  .out_clk_9mhz(clk),
  .out_clk_lock(clk_lock)
);

wire clk_9mhz = clk & clk_lock;

wire [9:0] pixelx;
wire [9:0] pixely;

wire ssync;

TftLcd_480_272 lcd(
    .in_rst(reset),
    .in_9mhz_clk(clk_9mhz),

    .out_en(lcd_en),
    .out_hsync(lcd_hsync),
    .out_vsync(lcd_vsync),
    .out_ssync(ssync),

    .out_pixelx(pixelx),
    .out_pixely(pixely),
    .out_clk(lcd_clk)
);


// LedCounter #(
//     .WAIT_TIME(1)
//   )
// c (
//   .in_rst(reset),
//   .in_clk(ssync),
//   .out_led(led)
// );

reg [4:0] rdata;
reg [5:0] gdata;
reg [4:0] bdata;

reg [6:0] xtile;
reg [6:0] ytile;

// 60 x 34 8x8 squares
always @(posedge ssync) begin
  if (xtile == 59) begin
    xtile <= 0;
  end
  else begin
    xtile <= xtile + 1;
  end

  if (xtile == 59) begin
    ytile <= ytile + 1;
  end
  else if (ytile == 33) begin
    ytile <= 0;
  end
  else begin
    ytile <= ytile;
  end
end

wire [9:0] px1;
wire [9:0] py1;

always @(posedge clk_27mhz) begin
  
  if (   (pixelx >= xtile * 8 && pixelx < (xtile + 1) * 8)
      && (pixely >= ytile * 8 && pixely < (ytile + 1) * 8) ) begin
    rdata <= 5'b11111;
  end
  else begin
    rdata <= (pixely[3] ^ pixelx[3]) ? 5'b01111 : 0;
  end

  gdata <= (pixely[4] ^ pixelx[4]) ? 6'b001111 : 0;
  bdata <= (pixely[5] ^ pixelx[5]) ? 5'b01111 : 0;
end

assign led = ~xtile[5:0];
assign lcd_r = rdata;
assign lcd_g = gdata;
assign lcd_b = bdata;

// assign lcd_r = (pixely[3] ^ pixelx[3]) ? 5'b11111 : 0;
// assign lcd_g = (pixely[4] ^ pixelx[4]) ? 6'b111111 : 0;;
// assign lcd_b = (pixely[5] ^ pixelx[5]) ? 5'b11111 : 0;;

endmodule
