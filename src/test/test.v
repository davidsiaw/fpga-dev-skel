`ifdef TESTBENCH
`timescale 1ns/1ps

`include "src/modules/general/TickRegisterConstants.v"


module Decoder(
  input [7:0] in_instruction,
  output out_stack_push,
  output out_stack_pop

);
endmodule















module test;

reg clk, rst = 1;
always #1 clk = ~clk;

wire e0;
wire e1;
wire e2;
wire e3;
wire e4;
wire e5;
Counter cnt(rst, clk, {e5,e4,e3,e2,e1,e0});


wire [7:0] stuff;
TickRegister ir(rst, clk, 8'h5, `TICK_REGISTER_MODE_SET & {e2, e1}, stuff);


wire [3:0] stuff1;
Register #(.SIZE(4)) rr (rst, clk, {e3, e2, e1, e0}, 1'b1, stuff1);

integer i;
initial begin
  $dumpfile("wave.vcd"); 
  $dumpvars(0, test);

  clk = 0;
  @(negedge clk);

  for (i = 0; i < 2; i = i + 1) begin
      $monitor("t=%-4d: i = %d", $time, i);
      @(negedge clk);
  end

  rst = 0;

  for (i = 0; i < 100; i = i + 1) begin
      $monitor("t=%-4d: i = %d", $time, i);
      @(negedge clk);
  end

  $finish();
end

endmodule
`endif // TESTBENCH
