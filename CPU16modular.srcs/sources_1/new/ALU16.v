`timescale 1ns / 1ps

module ALU16(
    input [15:0] a,      // rs1
    input [15:0] b,      // rs2  
    input [15:0] acc,    // R1 (accumulator)
    input [2:0] op,
    output reg [15:0] result
);

always @(*) begin
    case(op)
        3'b000: result = a + b;                    // ADD
        3'b001: result = a - b;                    // SUB  
        3'b010: result = a & b;                    // AND
        3'b011: result = a | b;                    // OR
        3'b100: result = a ^ b;                    // XOR
        3'b101: result = a * b;                    // MUL
        
        //Not of Acc till now just a
        3'b110: result = ~a ;
        
        default: result = 16'b0;
    endcase
end
endmodule