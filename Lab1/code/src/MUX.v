module MUX (
    a_i,
    b_i,
    sel_i,
    y_o
);

input [31:0] a_i;
input [31:0] b_i;
input sel_i;
output [31:0] y_o;

assign y_o = (sel_i == 1) ? b_i : a_i;
    
endmodule