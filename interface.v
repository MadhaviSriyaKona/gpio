`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 21:50:31
// Design Name: 
// Module Name: interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module interface (
    input        sys_clk,
    input        sys_rst,
    input  [7:0] gpio_data_out,
    input  [7:0] gpio_oe,          
    output [7:0] gpio_data_in,
    inout  [7:0] pad_io        
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : io_buf
        assign pad_io[i] = gpio_oe[i] ? gpio_data_out[i] : 1'bz;
        assign gpio_data_in[i] = pad_io[i];
    end
endgenerate
endmodule
