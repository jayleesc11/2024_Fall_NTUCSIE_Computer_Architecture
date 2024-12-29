module ALU (
    a_i,
    b_i,
    aluctr_i,
    result_o,
    zero_o
);

input [31:0] a_i;
input [31:0] b_i;
input [3:0] aluctr_i;
output reg [31:0] result_o;
output zero_o;

always @(*)
    case (aluctr_i)
        4'b0111: result_o = a_i & b_i;        // and
        4'b0100: result_o = a_i ^ b_i;        // xor
        4'b0001: result_o = a_i << b_i;       // sll
        4'b0000: result_o = a_i + b_i;        // add
        4'b1000: result_o = a_i - b_i;        // sub
        4'b1111: result_o = a_i * b_i;        // mul
        4'b1101: result_o = a_i >>> b_i[4:0]; // srai
        default: result_o = 0;
    endcase

assign zero_o = (result_o == 0);
    
endmodule