module ALU_Control (
    funct7_i,
    funct3_i,
    aluop_i,
    aluctr_o
);

input [6:0] funct7_i;
input [2:0] funct3_i;
input [1:0] aluop_i;
output reg [3:0] aluctr_o;

always @(*)
    case (aluop_i)
        // R-type: and, xor, sll, add, sub, mul
        2'b10:
            case (funct3_i)
                3'b111: aluctr_o = 4'b0111; // and
                3'b100: aluctr_o = 4'b0100; // xor
                3'b001: aluctr_o = 4'b0001; // sll
                3'b000:
                    case ({funct7_i[5], funct7_i[0]})
                        2'b00: aluctr_o = 4'b0000; // add
                        2'b10: aluctr_o = 4'b1000; // sub
                        2'b01: aluctr_o = 4'b1111; // mul
                        default: aluctr_o = 4'b0000;
                    endcase
                default: aluctr_o = 4'b0000;
            endcase
        // I-type: addi, srai, lw
        // S-type: sw
        2'b00:
            case (funct3_i)
                3'b000: aluctr_o = 4'b0000; // addi
                3'b101: aluctr_o = 4'b1101; // srai
                3'b010: aluctr_o = 4'b0000; // lw, sw: add
                default: aluctr_o = 4'b0000;
            endcase
        default: aluctr_o = 4'b0000;
    endcase
    
endmodule