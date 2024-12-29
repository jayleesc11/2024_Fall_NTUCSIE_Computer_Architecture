module Sign_Extend (
    imm_i,
    immext_o
);

input [11:0] imm_i;
output [31:0] immext_o;

assign immext_o = {{20{imm_i[11]}}, imm_i[11:0]};

endmodule