`timescale 1ns / 1ps

module NN(
    input [15:0] x1,
    input [15:0] x2,
    input [15:0] w1,
    input [15:0] w2,
    input [15:0] b,
    output [31:0] y
);

assign y = (x1 * w1) + (x2 * w2) + b;

endmodule