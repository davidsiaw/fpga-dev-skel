// Just a D-Flipflop with reset.

module Dffr(
  input rst,
  input clk,
  input d,
  output q
);

reg state;

always @(posedge clk) begin
  if (rst) begin
    state <= 0;
  end
  else begin
    state <= d;
  end
end

assign q = state;

endmodule
