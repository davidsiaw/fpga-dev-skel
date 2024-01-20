module Register #(
  parameter SIZE=8
) (
  input             in_rst,
  input             in_clk,
  input  [SIZE-1:0] in_val,
  input             in_write,
  output [SIZE-1:0] out_val
);

reg [SIZE-1:0] state;

always @(posedge in_clk, posedge in_rst) begin
  if (in_rst) begin
    state <= 0;
  end
  else if (in_write) begin
    state <= in_val;
  end
  else begin
    state <= state;
  end
end

assign out_val = state;

endmodule
