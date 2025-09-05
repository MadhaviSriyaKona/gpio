`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 21:52:17
// Design Name: 
// Module Name: tb_interface
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


module tb_interface;

    reg         sys_clk;
    reg         sys_rst;
    reg  [7:0]  gpio_data_out;
    reg  [7:0]  gpio_oe;
    wire [7:0]  gpio_data_in;
    wire [7:0]  pad_io;

    reg  [7:0]  pad_driver;
    reg  [7:0]  pad_drive_en;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pad_model
            assign pad_io[i] = pad_drive_en[i] ? pad_driver[i] : 1'bz;
        end
    endgenerate

    interface dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gpio_data_out(gpio_data_out),
        .gpio_oe(gpio_oe),
        .gpio_data_in(gpio_data_in),
        .pad_io(pad_io)
    );

    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk;

    initial begin
        sys_rst = 1;
        gpio_data_out = 8'b0;
        gpio_oe = 8'b0;
        pad_driver = 8'b0;
        pad_drive_en = 8'b0;

        #10 sys_rst = 0;

        gpio_data_out = 8'b10101010;
        gpio_oe = 8'b11111111;
        #10;

        gpio_oe = 8'b00000000;
        pad_drive_en = 8'b11111111;
        pad_driver = 8'b11001100;
        #10;

        gpio_oe = 8'b11110000;
        gpio_data_out = 8'b00111100;
        pad_driver = 8'b10101010;
        pad_drive_en = 8'b00001111;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | OE=%b | OUT=%b | PAD=%b | IN=%b", 
                 $time, gpio_oe, gpio_data_out, pad_io, gpio_data_in);
    end

endmodule

