`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2026 16:43:42
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
    input [15:0] addr,
    output [15:0] instr
    );
    reg [15:0] mem [0:255];

    // Load machine code from program.txt
   /* initial begin
        $readmemh(
            "E:/vhdl programs/CPU16modular/CPU16modular.srcs/sim_1/new/program.txt",
            mem
        );
        */
        integer i;

        initial begin
            for (i = 0; i < 256; i = i + 1)
                mem[i] = 16'h0000; // default NOP
        
        $readmemh("E:/vhdl programs/CPU16modular/CPU16modular.srcs/sim_1/new/program.txt", mem);
        
        $display("Instruction Loaded:");
        $display("mem[0] = %h", mem[0]);
        $display("mem[1] = %h", mem[1]);
        $display("mem[2] = %h", mem[2]);
    end

    // Since PC increases by 2:
    // PC = 0,2,4,6...
    // convert to memory index using >> 1
     assign instr = mem[addr >> 1];
     

endmodule
