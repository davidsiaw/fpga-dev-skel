`ifdef TESTBENCH
`timescale 1ns/100ps

module Clk_9MHZ
(
  input in_clk_27mhz,
  output out_clk_90mhz,
  output out_clk_9mhz,
  output out_clk_lock
);

reg clk;
initial clk = 0;
always #111 clk = ~clk;

assign out_clk_9mhz = clk;

endmodule

module Clk_27MHZ
(
  output out_clk_27mhz
);

reg clk;
initial clk = 0;
always #37 clk = ~clk;

assign out_clk_27mhz = clk;

endmodule

module test;

reg clk9;
always #111 clk9 = ~clk9;

wire [3:0] cnt;

reg rst = 1;
wire en, hsync, vsync, clk;


TftLcd_480_272 t(
    /*input       */ .in_rst(rst),
    /*input       */ .in_9mhz_clk(clk9),
    /*output      */ .out_en(en), /* drive enable */
    /*output      */ .out_hsync(hsync),
    /*output      */ .out_vsync(vsync),
    // /*output      */ .out_ssync,
    // /*output [9:0]*/ .out_pixelx,
    // /*output [9:0]*/ .out_pixely,
    /*output      */ .out_clk(clk)
);

integer i;
initial begin
  $dumpfile("wave.vcd"); 
  $dumpvars(0, test);

  clk9 = 0;
  @(negedge clk9);

  for (i = 0; i < 5; i = i + 1) begin
      $monitor("t=%-4d: i = %d", $time, i);
      @(negedge clk9);
  end

  rst = 0;

  for (i = 0; i < 400000; i = i + 1) begin
      $monitor("t=%-4d: i = %d", $time, i);
      @(negedge clk9);
  end

  $finish();
end

endmodule
`endif // TESTBENCH
