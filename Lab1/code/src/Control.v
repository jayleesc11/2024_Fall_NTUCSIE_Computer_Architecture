module Control (
    part_opcode_i,
    aluop_o,
    alusrc_o,
    regwrite_o
);

input [5:0] part_opcode_i;
output reg [1:0] aluop_o;
output reg alusrc_o;
output reg regwrite_o;

always @(*) begin
    case(part_opcode_i)
        // R-type: and, xor, sll, add, sub, mul
        6'b011001: begin
            aluop_o = 2'b10;
            alusrc_o = 0;
            regwrite_o = 1;
        end
        // I-type: addi, srai
        6'b001001: begin
            aluop_o = 2'b00;
            alusrc_o = 1;
            regwrite_o = 1;
        end
        default: begin
            aluop_o = 2'b00;
            alusrc_o = 0;
            regwrite_o = 0;
        end
    endcase
end
    
endmodule