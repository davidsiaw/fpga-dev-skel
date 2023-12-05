// https://dl.sipeed.com/shareURL/TANG/Nano%209K/6_Chip_Manual/EN/LCD_Datasheet
module TftLcd_800_480
(
    input         in_rst,
    input         in_30mhz_clk,

    output        out_clk,
    output        out_en,
    output        out_hsync,
    output        out_vsync,
    output        out_ssync,
    output [10:0] out_pixelx,
    output [10:0] out_pixely
);

  TftLcd_Base #(
    .H_PIXEL_LENGTH(800),
    .H_FRONT_PORCH (210),
    .H_SYNC_LENGTH (  1),
    .H_BACK_PORCH  ( 45),

    .V_PIXEL_LENGTH(480),
    .V_FRONT_PORCH ( 22),
    .V_SYNC_LENGTH (  3),
    .V_BACK_PORCH  ( 20),

    .PIXELX_WIDTH  ( 10),
    .PIXELY_WIDTH  ( 10),

    // These numbers were found via trial and error.
    // These represent the clock delay with which a module receiving
    // pixelx and pixely values must set the appropriate pixel colors
    .DELAY_X       (  -77),
    .DELAY_Y       (  -16)

  ) impl (

    .in_rst(in_rst),
    .in_clk(in_30mhz_clk),

    .out_en(out_en),
    .out_hsync(out_hsync),
    .out_vsync(out_vsync),
    .out_ssync(out_ssync),

    .out_pixelx(out_pixelx),
    .out_pixely(out_pixely),

    .out_clk(out_clk)
  );

endmodule
