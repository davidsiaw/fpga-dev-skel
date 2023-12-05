// https://dl.sipeed.com/shareURL/TANG/Nano%209K/6_Chip_Manual/EN/LCD_Datasheet
module TftLcd_480_272
(
    input        in_rst,
    input        in_9mhz_clk,

    output       out_clk,
    output       out_en,
    output       out_hsync,
    output       out_vsync,
    output       out_ssync,
    output [9:0] out_pixelx,
    output [9:0] out_pixely
);

  TftLcd_Base #(
    .H_PIXEL_LENGTH(480),
    .H_FRONT_PORCH (  4),
    .H_SYNC_LENGTH (  4),
    .H_BACK_PORCH  ( 39),

    .V_PIXEL_LENGTH(272),
    .V_FRONT_PORCH (  4),
    .V_SYNC_LENGTH (  4),
    .V_BACK_PORCH  (  8),

    .PIXELX_WIDTH  (  9),
    .PIXELY_WIDTH  (  9),

    // These numbers were found via trial and error.
    // These represent the clock delay with which a module receiving
    // pixelx and pixely values must set the appropriate pixel colors
    .DELAY_X       (  -77),
    .DELAY_Y       (  -16)

  ) impl (

    .in_rst(in_rst),
    .in_clk(in_9mhz_clk),

    .out_en(out_en),
    .out_hsync(out_hsync),
    .out_vsync(out_vsync),
    .out_ssync(out_ssync),

    .out_pixelx(out_pixelx),
    .out_pixely(out_pixely),

    .out_clk(out_clk)
  );

endmodule
