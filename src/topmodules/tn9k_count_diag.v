module tn9k_count_diag
(
    input        clk_27mhz,
    input        rst_btn,
    output [5:0] led
);

  reg [31:0] cnt = 0;
  always @(posedge clk_27mhz) begin
    cnt <= cnt + 1;
  end
  assign led = ~cnt[25:20];

endmodule
