module MUX_4Way (
    a_i,
    b_i,
    c_i,
    d_i,
    sel_i,
    y_o
);

input [31:0] a_i;
input [31:0] b_i;
input [31:0] c_i;
input [31:0] d_i;
input [1:0] sel_i;
output [31:0] y_o;

MUX MUX1(
    .a_i(a_i),
    .b_i(b_i),
    .sel_i(sel_i[0]),
    .y_o()
);

MUX MUX2(
    .a_i(c_i),
    .b_i(d_i),
    .sel_i(sel_i[0]),
    .y_o()
);

MUX MUXFinal(
    .a_i(MUX1.y_o),
    .b_i(MUX2.y_o),
    .sel_i(sel_i[1]),
    .y_o(y_o)
);
    
endmodule