// module VgaMod_800_480
// (
//     input                   clk_33_3mhz,
//     input                   rst,

//     input                   pixel_clk,

//     output                  lcd_de, /* drive enable */
//     output                  hsync,
//     output                  vsync,

//     output          [4:0]   b,
//     output          [5:0]   g,
//     output          [4:0]   r
// );

// localparam      pixel_width   = 16'd800;
// localparam      pixel_height  = 16'd480;

// localparam      V_BackPorch = 16'd6; //0 or 45
// localparam      V_Pluse   = 16'd5; 
// localparam      V_FrontPorch= 16'd62; //45 or 0

// localparam      H_BackPorch = 16'd182;  
// localparam      H_Pluse   = 16'd1; 
// localparam      H_FrontPorch= 16'd210;

// localparam      PixelForHS  =   WidthPixel + H_BackPorch + H_FrontPorch;    
// localparam      LineForVS   =   HightPixel + V_BackPorch + V_FrontPorch;


// endmodule


module top
(
    input  wire clk_27mhz,
    input  wire rst_btn,
    output wire [5:0] led
);

//assign led = ~6'b011000;

LedCounter #(
    .WAIT_TIME(5048576)
  )
c (
  .in_rst(rst_btn),
  .in_clk(clk_27mhz),
  .out_led(led)
);

endmodule
