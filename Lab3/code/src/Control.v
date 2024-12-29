module Control (
    no_op_i,
    part_opcode_i,
    regwrite_o,
    memtoreg_o,
    memread_o,
    memwrite_o,
    aluop_o,
    alusrc_o,
    branch_o
);

input no_op_i;
input [5:0] part_opcode_i;
output reg regwrite_o;
output reg memtoreg_o;
output reg memread_o;
output reg memwrite_o;
output reg [1:0] aluop_o;
output reg alusrc_o;
output reg branch_o;

always @(*)
    if(no_op_i) begin
        regwrite_o = 0;
        memtoreg_o = 0;         // don't care
        memread_o = 0;          // don't care
        memwrite_o = 0;
        aluop_o = 2'b00;        // don't care
        alusrc_o = 0;           // don't care
        branch_o = 0;
    end else case(part_opcode_i)
        // R-type: and, xor, sll, add, sub, mul
        6'b011001: begin
            regwrite_o = 1;
            memtoreg_o = 0;
            memread_o = 0;
            memwrite_o = 0;
            aluop_o = 2'b10;
            alusrc_o = 0;
            branch_o = 0;
        end
        // I-type: addi, srai
        6'b001001: begin
            regwrite_o = 1;
            memtoreg_o = 0;
            memread_o = 0;
            memwrite_o = 0;
            aluop_o = 2'b00;
            alusrc_o = 1;
            branch_o = 0;
        end
        // I-type: lw
        6'b000001: begin
            regwrite_o = 1;
            memtoreg_o = 1;
            memread_o = 1;
            memwrite_o = 0;
            aluop_o = 2'b00;
            alusrc_o = 1;
            branch_o = 0;
        end
        // S-type: sw
        6'b010001: begin
            regwrite_o = 0;
            memtoreg_o = 0;         // don't care
            memread_o = 0;
            memwrite_o = 1;
            aluop_o = 2'b00;
            alusrc_o = 1;
            branch_o = 0;
        end
        // B-type: beq
        6'b110001: begin
            regwrite_o = 0;
            memtoreg_o = 0;         // don't care
            memread_o = 0;
            memwrite_o = 0;
            aluop_o = 2'b01;
            alusrc_o = 0;
            branch_o = 1;
        end
        default: begin
            regwrite_o = 0;
            memtoreg_o = 0;
            memread_o = 0;
            memwrite_o = 0;
            aluop_o = 2'b00;
            alusrc_o = 0;
            branch_o = 0;
        end
    endcase
    
endmodule