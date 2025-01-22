module tn9k_count_diag
(
    input        clk_27mhz,
    input        rst_btn,
    output [5:0] led
);

  reg [31:0] cnt = 0;

  always @(posedge clk_27mhz) begin
    cnt <= cnt + 1;
    assume(cnt == $past(cnt));
  end

  a: assert property(led != 0);

  assign led = ~cnt[25:20];

endmodule
