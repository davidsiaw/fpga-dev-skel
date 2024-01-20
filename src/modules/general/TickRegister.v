// A register capable of incrementing and decrementing itself
// can also be set to a particular value.

// By providing the following constants you can
// program its behavior
`include "TickRegisterConstants.v"

module TickRegister #(
  parameter SIZE=8
) (
  input             in_rst,
  input             in_clk,
  input  [SIZE-1:0] in_val,
  input  [1:0]      in_mode,
  output [SIZE-1:0] out_val
);

reg [SIZE-1:0] c_val;
reg            c_write;

always @(*) begin
  case(in_mode)
    `TICK_REGISTER_MODE_INC: begin
      c_val = out_val + 1;
      c_write = 1;
    end

    `TICK_REGISTER_MODE_DEC: begin
      c_val = out_val - 1;
      c_write = 1;
    end

    `TICK_REGISTER_MODE_SET: begin
      c_val = in_val;
      c_write = 1;
    end

    default: begin
      c_val = 0;
      c_write = 0;
    end
  endcase
end

Register #(
  .SIZE(SIZE)
) impl (
  .in_rst(in_rst),
  .in_clk(in_clk),
  .in_val(c_val),
  .in_write(c_write),
  .out_val(out_val)
);

endmodule
