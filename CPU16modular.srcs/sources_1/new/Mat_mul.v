module Mat_mul(
    input [15:0] a00,a01,a10,a11,
    input [15:0] b00,b01,b10,b11,
    output [15:0] c00,c01,c10,c11
);

assign c00 = (a00*b00) + (a01*b10);
assign c01 = (a00*b01) + (a01*b11);
assign c10 = (a10*b00) + (a11*b10);
assign c11 = (a10*b01) + (a11*b11);

endmodule