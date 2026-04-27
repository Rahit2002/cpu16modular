`timescale 1ns /1 ps
module CPU16(
    input clk,
    input rst,
    output [15:0] dbg
);

reg [15:0] pc;
wire [15:0] instr;

instr_mem IMEM(.addr(pc), .instr(instr));

wire [3:0] opcode = instr[15:12];
wire [2:0] rd     = instr[11:9];
wire [2:0] rs1    = instr[8:6]; 
wire [2:0] rs2    = instr[5:3];

wire [7:0] imm8   = instr[7:0];   // used only for LOADI#imm

wire [15:0] rdata1, rdata2, r0,r1,r2,r3,r4,r5,r6,r7;
reg wen;                     
reg [2:0] waddr;
reg [15:0] wdata;

reg_file RF(
    .clk(clk), .rst(rst), .wen(wen), .waddr(waddr), .wdata(wdata),
    .raddr1(rs1), .raddr2(rs2), .rdata1(rdata1), .rdata2(rdata2),
    .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7)
);

wire [15:0] alu_out;
wire [2:0] alu_op =
    (opcode == 4'h2) ? 3'b000 : // ADD
    (opcode == 4'h3) ? 3'b001 : // SUB
    (opcode == 4'h4) ? 3'b010 : // AND
    (opcode == 4'h5) ? 3'b011 : // OR
    (opcode == 4'h6) ? 3'b100 : // XOR
    (opcode == 4'h7) ? 3'b101 : // MUL
    (opcode == 4'h8) ? 3'b110 : // MAC
    3'b111;                      // reserved

ALU16 ALU(.a(rdata1), .b(rdata2), .acc(r1), .op(alu_op), .result(alu_out));

wire [31:0] nn_out;
NN NN0(.x1(rdata1), .x2(rdata2), .w1(rdata1), .w2(rdata2), .b(r7), .y(nn_out));

wire [15:0] c00,c01,c10,c11;
Mat_mul MM(
    .a00(r0), .a01(r1), .a10(r2), .a11(r3),
    .b00(r4), .b01(r5), .b10(r6), .b11(r7),
    .c00(c00), .c01(c01), .c10(c10), .c11(c11)
);
wire [15:0] mac_out;
MAC MAC0(
    .a(rdata1),
    .b(rdata2),
    .acc(r1),
    .result(mac_out)
);
assign dbg = r1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc    <= 0;
        wen   <= 0;
        waddr <= 0;
        wdata <= 0;
    end else begin
        wen <= 0;
        pc  <= pc + 2;

        case(opcode)
            4'h0: ; // Eat 5*

            4'h1: begin // LoadI
                wen   <= 1;
                waddr <= rd;
                wdata <= {8'b0, imm8};
            end

            4'h2: begin // ADD
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h3: begin // SUB
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h4: begin // AND
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h5: begin // OR
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h6: begin // XOR
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h7: begin // MUL
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h8: begin // MAC (acc = R1)
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;
            end

            4'h9: begin // NN
                wen   <= 1;
                waddr <= rd;
                wdata <= nn_out[15:0];
            end

            4'hA: begin // MMAT00
                wen   <= 1;
                waddr <= rd;
                wdata <= c00;
            end

            4'hB: begin // MOV R,R
                wen   <= 1;
                waddr <= rd;
                wdata <= rdata1;
            end
//            MOV rd rs1
//            4'hC: begin
//                wen   <= 1;
//                waddr <= rd;
//                wdata <= rdata1;   // R[rd] ? R[rs1]
//            end
            4'hC: begin
                wen   <= 1;
                waddr <= rd;
                wdata <= mac_out;   // R[rd] ? R[rs1]
            end
            
            4'hD: begin
                wen   <= 1;
                waddr <= rd;
                wdata <= alu_out;   
            end

            4'hF: begin // EXIT
                $display("FINAL: R0=%h R1=%h R2=%h", r0,r1,r2);
                #5 $finish;
            end

            default: ; // NOP
        endcase
    end
end

endmodule