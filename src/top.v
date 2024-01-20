`ifndef TESTBENCH

module top
(
    input        rst_btn,
    output [5:0] led
);

wire mclk;

wire clk2;
wire clk3;
wire clk4;
wire clk5;
wire clk6;
wire clk7;

OSC #(.FREQ_DIV(128)) osc (.OSCOUT(mclk));

CLKDIV #(.DIV_MODE(8)) div1 (
  .HCLKIN(mclk),
  .RESETN(1'b1),
  .CALIB(1'b0),
  .CLKOUT(clk2)
);

CLKDIV #(.DIV_MODE(8)) div2 (
  .HCLKIN(clk2),
  .RESETN(1'b1),
  .CALIB(1'b0),
  .CLKOUT(clk3)
);

CLKDIV #(.DIV_MODE(8)) div3 (
  .HCLKIN(clk3),
  .RESETN(1'b1),
  .CALIB(1'b0),
  .CLKOUT(clk4)
);

CLKDIV #(.DIV_MODE(8)) div4 (
  .HCLKIN(clk4),
  .RESETN(1'b1),
  .CALIB(1'b0),
  .CLKOUT(clk5)
);

CLKDIV #(.DIV_MODE(8)) div5 (
  .HCLKIN(clk5),
  .RESETN(1'b1),
  .CALIB(1'b0),
  .CLKOUT(clk6)
);

CLKDIV #(.DIV_MODE(8)) div6 (
  .HCLKIN(clk6),
  .RESETN(1'b1),
  .CALIB(1'b0),
  .CLKOUT(clk7)
);

// // reg [5:0] cnt;
// // always @(posedge clk7) begin
// //   cnt <= cnt + 1;
// // end
// // assign led = cnt;

// wire aq;
// Divider a(clk7, aq);

// wire bq;
// Divider b(aq, bq);

// wire cq;
// Divider c(bq, cq);

// wire dq;
// Divider d(cq, dq);

// wire eq;
// Divider e(dq, eq);

// wire fq;
// Divider f(eq, fq);

// assign led = { fq, eq, dq, cq, bq, aq };

// endmodule

// module Ender(
//   input clk,
//   input in,
//   output q
// );

// reg lowbit;
// reg highbit;

// always @(posedge clk) begin
//   lowbit <= in;
//   if (lowbit != in) begin
//     highbit <= ~highbit;
//   end
//   else begin
//     highbit <= highbit;
//   end
// end

// assign q = highbit;

endmodule

module Divider(
  input rst,
  input clk,
  output q
);

wire qn;
Dff a(
  .rst(rst),
  .clk(clk),
  .d(qn),
  .q(q)
);
assign qn = ~q;

endmodule

`endif // TESTBENCH
