module TftLcd_480_272
(
    input        in_rst,
    input        in_9mhz_clk,

    output       out_en, /* drive enable */
    output       out_hsync,
    output       out_vsync,
    output       out_ssync,

    output [9:0] out_pixelx,
    output [9:0] out_pixely,

    output       out_clk
);

// These timing numbers do not correspond with anything that is written in the
// datasheet provided at https://dl.sipeed.com/TANG/Nano%209K/6_Chip_Manual/EN/LCD_Datasheet/
// These numbers come from analyzing code that works from
// https://dl.sipeed.com/TANG/Nano%209K/6_Chip_Manual/EN/LCD_Datasheet/
// ¯\_(ツ)_/¯ tbh
localparam      pixel_width   = 9'd480; // 9MHz Th=531 >= pixel_width + h_back_porch + h_front_porch
localparam      h_front_porch = 9'd4;   //                   480      +      43      +       4
localparam      hsync_pulse   = 9'd4;    // < h_back_porch?
localparam      h_back_porch  = 9'd39;

localparam      pixel_height  = 9'd272; // 9MHz Tv=292 >= pixel_height + v_back_porch + v_front_porch
localparam      v_front_porch = 9'd4;  //         292 >=    272       +     12       +     4
localparam      vsync_pulse   = 9'd4;     // < v_back_porch?
localparam      v_back_porch  = 9'd8;    //

reg [9:0] c_hcounter;
reg [9:0] c_vcounter;
reg [5:0] c_fcounter;

reg c_ssync;

reg [9:0] c_pixelx;
reg [9:0] c_pixely;

always_comb begin
  if (in_rst == 1) begin
    c_hcounter = 0;
    c_vcounter = 0;
    c_fcounter = 0;

    c_ssync    = 0;

    c_pixelx   = 0;
    c_pixely   = 0;
  end
  else begin

    if      (r_hcounter == hsync_pulse + h_back_porch + pixel_width + h_front_porch) begin
      c_hcounter = 0;
    end
    else begin
      c_hcounter = r_hcounter + 1;
    end

    if      (r_vcounter == vsync_pulse + v_back_porch + pixel_height + v_front_porch) begin
      c_vcounter = 0;
    end
    else if (r_hcounter == hsync_pulse + h_back_porch + pixel_width + h_front_porch) begin
      c_vcounter = r_vcounter + 1;
    end
    else begin
      c_vcounter = r_vcounter;
    end

    if      (r_vcounter == vsync_pulse + v_back_porch + pixel_height + v_front_porch) begin
      c_fcounter = r_fcounter + 1;
    end
    else if (r_fcounter == 59) begin
      c_fcounter = 0;
    end
    else begin
      c_fcounter = r_fcounter;
    end

    if (r_fcounter == 59) begin
      c_ssync = 1;
    end
    else begin
      c_ssync = 0;
    end
  end

  // These numbers were found via trial and error.
  // These represent the clock delay with which a module receiving
  // pixelx and pixely values must set the appropriate pixel colors
  `define DELAY_X 1;
  `define DELAY_Y 7;

  c_pixelx = r_hcounter - hsync_pulse - h_back_porch + `DELAY_X;
  c_pixely = r_vcounter - vsync_pulse - v_back_porch + `DELAY_Y;

  `undef DELAY_X
  `undef DELAY_Y
end

reg [9:0] r_hcounter;
reg [9:0] r_vcounter;
reg [5:0] r_fcounter;

reg r_ssync;

reg [9:0] r_pixelx;
reg [9:0] r_pixely;

always_ff @(posedge in_9mhz_clk) begin
  r_hcounter <= c_hcounter;
  r_vcounter <= c_vcounter;
  r_fcounter <= c_fcounter;

  r_ssync    <= c_ssync;

  r_pixelx   <= c_pixelx;
  r_pixely   <= c_pixely;
end

assign out_hsync   = r_hcounter < hsync_pulse ? 0 : 1;
assign out_vsync   = r_vcounter < vsync_pulse ? 0 : 1;
assign out_ssync   = r_ssync;

assign out_en      = (r_hcounter >= hsync_pulse + h_back_porch &&
                      r_hcounter <  hsync_pulse + h_back_porch + pixel_width && r_vcounter > vsync_pulse) ? 1 : 0;
assign out_pixelx  = r_pixelx;
assign out_pixely  = r_pixely;

assign out_clk     = in_9mhz_clk;

endmodule
