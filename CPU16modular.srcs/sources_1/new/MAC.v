`timescale 1ns / 1ps
module MAC(
    input [15:0] a,
    input [15:0] b,
    input [15:0] acc,
    output [31:0] result
    );
    assign result = acc + (a * b);
endmodule
