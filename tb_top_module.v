`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 22:14:11
// Design Name: 
// Module Name: tb_top_module
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
module tb_top_module;

    // APB inputs
    reg         pclk;
    reg         presetn;
    reg         psel;
    reg         penable;
    reg         pwrite;
    reg  [31:0] paddr;
    reg  [31:0] pwdata;
    wire [31:0] prdata;
    wire        pready;
    wire        irq;

    // AUX
    reg  [31:0] aux_in;

    // IO pad
    wire [31:0] io_pad;
    reg  [31:0] pad_driver;
    reg  [31:0] pad_drive_en;
    wire        ext_clk_pad_i;

    // Internal wire to model I/O
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : io_model
            assign io_pad[i] = pad_drive_en[i] ? pad_driver[i] : 1'bz;
        end
    endgenerate

    assign ext_clk_pad_i = pclk;  // simulate external clock from pclk

    // DUT
    top_module dut (
        .pclk        (pclk),
        .presetn     (presetn),
        .psel        (psel),
        .penable     (penable),
        .pwrite      (pwrite),
        .paddr       (paddr),
        .pwdata      (pwdata),
        .prdata      (prdata),
        .pready      (pready),
        .irq         (irq),
        .aux_in      (aux_in),
        .io_pad      (io_pad),
        .ext_clk_pad_i (ext_clk_pad_i)
    );

    // Clock gen
    initial pclk = 0;
    always #5 pclk = ~pclk;

    initial begin
        // Init
        presetn = 0;
        psel    = 0;
        penable = 0;
        pwrite  = 0;
        paddr   = 0;
        pwdata  = 0;
        aux_in  = 32'hCAFEBABE;
        pad_driver = 32'h0;
        pad_drive_en = 32'h0;

        #20;
        presetn = 1;

        // --- Write GPIO_OUT register (0x04) ---
        apb_write(32'h04, 32'hAAAAAAAA);

        // --- Write GPIO_OE register (0x08) to enable all outputs ---
        apb_write(32'h08, 32'hFFFFFFFF);

        // Wait and observe io_pad driven
        #20;

        // --- Read GPIO_IN (0x00) ---
        // Set pad driver to simulate external input
        pad_drive_en = 32'hFFFFFFFF;
        pad_driver   = 32'h55AA55AA;

        apb_read(32'h00);

        // --- Write interrupt enable & ptrig ---
        apb_write(32'h0C, 32'h0000FFFF);  // INTE
        apb_write(32'h10, 32'h00000000);  // PTRIG
        #10;
        pad_driver = 32'h000000FF;       // change input to trigger ints
        #10;

        // Read INTS register
        apb_read(32'h1C);

        #50;
        $finish;
    end

    // APB Tasks
    task apb_write(input [31:0] addr, input [31:0] data);
        begin
            @(posedge pclk);
            paddr   = addr;
            pwdata  = data;
            pwrite  = 1;
            psel    = 1;
            penable = 0;

            @(posedge pclk);
            penable = 1;

            @(posedge pclk);
            psel    = 0;
            penable = 0;
            pwrite  = 0;
        end
    endtask

    task apb_read(input [31:0] addr);
        begin
            @(posedge pclk);
            paddr   = addr;
            pwrite  = 0;
            psel    = 1;
            penable = 0;

            @(posedge pclk);
            penable = 1;

            @(posedge pclk);
            $display("Read @ %h = %h", addr, prdata);
            psel    = 0;
            penable = 0;
        end
    endtask

endmodule




