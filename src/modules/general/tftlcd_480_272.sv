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

localparam      pixel_width   = 16'd480;
localparam      h_front_porch = 16'd50;
localparam      hsync_pulse = 16'd4;
localparam      h_back_porch = 16'd26;

localparam      pixel_height  = 16'd272;
localparam      v_front_porch = 16'd20;
localparam      vsync_pulse = 16'd4;
localparam      v_back_porch = 16'd1;

reg [9:0] c_hcounter;
reg [9:0] c_vcounter;
reg [5:0] c_fcounter;

reg c_hsync;
reg c_vsync;
reg c_ssync;

reg c_en;

reg [9:0] c_pixelx;
reg [9:0] c_pixely;

always_comb begin
	if (in_rst == 1) begin
		c_hcounter = 0;
		c_vcounter = 0;
		c_fcounter = 0;

		c_hsync = 1;
		c_vsync = 1;
		c_ssync = 0;

		c_en = 0;

		c_pixelx = 0;
		c_pixely = 0;

	end
	else begin
		if      (r_hcounter == hsync_pulse + h_back_porch) begin
			c_en = 1;
		end
		else if (r_hcounter == hsync_pulse + h_back_porch + pixel_width) begin
			c_en = 0;
		end
		else begin
			c_en = r_en;
		end

		if      (r_hcounter == hsync_pulse) begin
			c_hsync = 1;
		end
		else if (r_hcounter == hsync_pulse + h_back_porch + pixel_width + h_front_porch) begin
			c_hsync = 0;
		end
		else begin
			c_hsync = r_hsync;
		end

		if  (r_vcounter == vsync_pulse) begin
			c_vsync = 1;
		end
		else if (r_vcounter == vsync_pulse + v_back_porch + pixel_height + v_front_porch) begin
			c_vsync = 0;
		end
		else begin
			c_vsync = r_vsync;
		end

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
		else if (r_fcounter == 60) begin
			c_fcounter = 0;
		end
		else begin
			c_fcounter = r_fcounter;
		end

		if (r_fcounter == 60) begin
			c_ssync = 1;
		end
		else begin
			c_ssync = 0;
		end
	end

	c_pixelx = r_hcounter - hsync_pulse + h_back_porch;
	c_pixely = r_vcounter - vsync_pulse + v_back_porch - 1;
end

reg [9:0] r_hcounter;
reg [9:0] r_vcounter;
reg [5:0] r_fcounter;

reg r_hsync;
reg r_vsync;
reg r_ssync;

reg r_en;

reg [9:0] r_pixelx;
reg [9:0] r_pixely;

always_ff @(posedge in_9mhz_clk) begin
	r_hcounter <= c_hcounter;
	r_vcounter <= c_vcounter;
	r_fcounter <= c_fcounter;

	r_hsync <= c_hsync;
	r_vsync <= c_vsync;
	r_ssync <= c_ssync;
	r_en <= c_en;

	r_pixelx <= c_pixelx;
	r_pixely <= c_pixely;
end

assign out_hsync   = r_hsync;
assign out_vsync   = r_vsync;
assign out_ssync   = r_ssync;

assign out_en      = r_en & in_9mhz_clk & ~in_rst;
assign out_pixelx  = r_pixelx;
assign out_pixely  = r_pixely;

assign out_clk     = in_9mhz_clk & ~in_rst;

endmodule
