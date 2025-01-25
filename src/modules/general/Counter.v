module Counter #(
  parameter SIZE=5
) (
  input           rst,
  input           clk,
  output [SIZE-1:0] q
);

reg [SIZE-1:0] state;

always @(posedge clk) begin
  if (rst) begin
    state <= {SIZE{1'b0}};
  end
  else begin
    state <= state + 1'b1;
  end
end

assign q = state;

endmodule
