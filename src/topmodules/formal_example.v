module formal_example
(
  input        clk_27mhz,
  input        rst_btn,
  output [5:0] led
);

  reg [31:0] cnt = 0;

  always @(posedge clk_27mhz) begin
    if (cnt == 5) begin
      cnt <= 0;
    end
    else begin
      cnt <= cnt + 1;
    end

    `ifdef FORMAL
      assert(cnt != 6);
    `endif

  end

  assign led = ~cnt[25:20];

endmodule
