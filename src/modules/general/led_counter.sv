// Return the max bit for a particular value
function int value_max_bit;
  input int value;

  return $clog2(value + 1);

endfunction

module LedCounter
#(
  parameter WAIT_TIME = 1048576
)
(
  input in_rst,
  input in_clk,
  output [5:0] out_led 
);

localparam COUNTER_WIDTH = value_max_bit(WAIT_TIME);

reg [5:0]             c_led_counter;
reg [COUNTER_WIDTH:0] c_clock_counter;

always_comb begin
  if (in_rst == 1) begin
    c_clock_counter = 0;
    c_led_counter = 0;
  end
  else if (r_clock_counter == WAIT_TIME) begin
    c_led_counter = r_led_counter + 1'b1;
    c_clock_counter = 0;
  end
  else begin
    c_led_counter = r_led_counter;
    c_clock_counter = r_clock_counter + 1'b1;
  end
end


reg [5:0]             r_led_counter;
reg [COUNTER_WIDTH:0] r_clock_counter;

always_ff @(posedge in_clk) begin
  r_led_counter <= c_led_counter;
  r_clock_counter <= c_clock_counter;
end

assign out_led = ~r_led_counter;

endmodule
