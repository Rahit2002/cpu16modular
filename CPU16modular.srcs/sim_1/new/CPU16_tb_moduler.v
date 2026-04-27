`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2026 18:08:56
// Design Name: 
// Module Name: CPU16_tb_moduler
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


module CPU16_tb_moduler;


//============================================================
// tb_CPU16.v
// Testbench for CPU16
//============================================================

    // Inputs
    reg clk;
    reg rst;

    // Output
    wire [15:0] dbg;

    //========================================================
    // DUT (Device Under Test)
    //========================================================
    CPU16 uut (
        .clk(clk),
        .rst(rst),
        .dbg(dbg)
    );

    //========================================================
    // Clock Generation
    // 10ns clock period
    //========================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //========================================================
    // Test Sequence
    //========================================================
    initial begin
        clk = 0;
        // Apply Reset
        rst = 1;
        #20;

        rst = 0;

        // Run simulation long enough
        #1000;

        $finish;
    end

    //========================================================
    // Monitor Values
    //========================================================
    initial begin
        $monitor(
            "Time=%0t | rst=%b | dbg(R1)=%h", $time, rst, dbg);
            
    end

endmodule