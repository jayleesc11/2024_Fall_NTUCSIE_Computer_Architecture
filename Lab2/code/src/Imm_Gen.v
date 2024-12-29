module Imm_Gen (
    instr_i,
    immext_o
);

input [31:0] instr_i;
output [31:0] immext_o;

reg [11:0] imm;

always @(*)
    case (instr_i[6:4])
        // I-type: addi, srai
        3'b001: imm = instr_i[31:20];
        // I-type: lw
        3'b000: imm = instr_i[31:20];
        // S-type: sw
        3'b010: imm = {instr_i[31:25], instr_i[11:7]};
        // B-type: beq
        3'b110: imm = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};        
        default: imm = 12'b0;
    endcase

assign immext_o = {{20{imm[11]}}, imm};

endmodule