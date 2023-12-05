module TftLcd_Base
#(
  parameter H_PIXEL_LENGTH = 480,
  parameter H_FRONT_PORCH  = 4,
  parameter H_SYNC_LENGTH  = 4,
  parameter H_BACK_PORCH   = 39,

  parameter V_PIXEL_LENGTH = 272,
  parameter V_FRONT_PORCH  = 4,
  parameter V_SYNC_LENGTH  = 4,
  parameter V_BACK_PORCH   = 8,

  parameter PIXELX_WIDTH   = 9,
  parameter PIXELY_WIDTH   = 9,

  parameter DELAY_X        = 1,
  parameter DELAY_Y        = 1
)
(
  input                   in_rst,
  input                   in_clk,

  output                  out_en,
  output                  out_hsync,
  output                  out_vsync,
  output                  out_ssync,

  output [PIXELX_WIDTH:0] out_pixelx,
  output [PIXELY_WIDTH:0] out_pixely,

  output                  out_clk
);

localparam HCOUNTER_WIDTH = $clog2(H_PIXEL_LENGTH + 1) + 1;
localparam VCOUNTER_WIDTH = $clog2(V_PIXEL_LENGTH + 1) + 1;

localparam HFRAMELENGTH = H_SYNC_LENGTH + H_BACK_PORCH + H_PIXEL_LENGTH + H_FRONT_PORCH;
localparam VFRAMELENGTH = V_SYNC_LENGTH + V_BACK_PORCH + V_PIXEL_LENGTH + V_FRONT_PORCH;

localparam HPIXELSTART = H_SYNC_LENGTH - H_BACK_PORCH;
localparam VPIXELSTART = V_SYNC_LENGTH - V_BACK_PORCH;

reg [HCOUNTER_WIDTH:0] c_hcounter;
reg [VCOUNTER_WIDTH:0] c_vcounter;
reg [5:0]              c_fcounter;

reg                    c_ssync;

reg [PIXELX_WIDTH:0]   c_pixelx;
reg [PIXELY_WIDTH:0]   c_pixely;

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

    if      (r_hcounter == HFRAMELENGTH) begin
      c_hcounter = 0;
    end
    else begin
      c_hcounter = r_hcounter + 1;
    end

    if      (r_vcounter == VFRAMELENGTH) begin
      c_vcounter = 0;
    end
    else if (r_hcounter == HFRAMELENGTH) begin
      c_vcounter = r_vcounter + 1;
    end
    else begin
      c_vcounter = r_vcounter;
    end

    if      (r_vcounter == VFRAMELENGTH) begin
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

  c_pixelx = r_hcounter - HPIXELSTART + DELAY_X;
  c_pixely = r_vcounter - VPIXELSTART + DELAY_Y;

end

reg [HCOUNTER_WIDTH:0] r_hcounter;
reg [VCOUNTER_WIDTH:0] r_vcounter;
reg [5:0]              r_fcounter;

reg                    r_ssync;

reg [PIXELX_WIDTH:0]   r_pixelx;
reg [PIXELY_WIDTH:0]   r_pixely;

always_ff @(posedge in_clk) begin
  r_hcounter <= c_hcounter;
  r_vcounter <= c_vcounter;
  r_fcounter <= c_fcounter;

  r_ssync    <= c_ssync;

  r_pixelx   <= c_pixelx;
  r_pixely   <= c_pixely;
end

assign out_hsync   = r_hcounter < H_SYNC_LENGTH ? 0 : 1;
assign out_vsync   = r_vcounter < V_SYNC_LENGTH ? 0 : 1;
assign out_ssync   = r_ssync;

assign out_en      = (r_hcounter >= HPIXELSTART &&
                      r_hcounter <  H_SYNC_LENGTH + H_BACK_PORCH + H_PIXEL_LENGTH &&
                      r_vcounter > V_SYNC_LENGTH) ? 1 : 0;

assign out_pixelx  = r_pixelx;
assign out_pixely  = r_pixely;

assign out_clk     = in_clk;

endmodule
