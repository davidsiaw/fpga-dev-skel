module tn9k_count_diag
(
    input        clk_27mhz,
    input        rst_btn,
    output [5:0] led
);

  reg [23:0] cnt;
  reg [5:0] lednum;

  always @(posedge clk_27mhz) begin
  	if ( cnt < 24'd12000000) begin
      cnt <= cnt + 1;
      lednum <= lednum;
    end
    else begin
      cnt <= 0;
      lednum <= lednum + 1;
    end
  end

  assign led = ~lednum;

endmodule
