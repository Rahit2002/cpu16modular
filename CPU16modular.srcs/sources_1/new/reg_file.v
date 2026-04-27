module reg_file(
    input clk,
    input rst,
    input wen,
    input [2:0] waddr,
    input [15:0] wdata,
    input [2:0] raddr1,
    input [2:0] raddr2,
    output reg [15:0] rdata1,
    output reg [15:0] rdata2,
    output [15:0] r0,r1,r2,r3,r4,r5,r6,r7  // ? Move outputs here
);

reg [15:0] regs [7:0];
integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i=0; i<8; i=i+1)
            regs[i] <= 16'h0;
    end else if (wen) begin
        regs[waddr] <= wdata;
    end
end

always @(*) begin
    rdata1 = regs[raddr1];
    rdata2 = regs[raddr2];
end

// ? Debug outputs
assign r0 = regs[0];
assign r1 = regs[1];
assign r2 = regs[2];
assign r3 = regs[3];
assign r4 = regs[4];
assign r5 = regs[5];
assign r6 = regs[6];
assign r7 = regs[7];

endmodule