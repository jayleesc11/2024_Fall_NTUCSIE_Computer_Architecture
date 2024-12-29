module Flush (
    rst_i,
    branch_i,
    rs1_data_i,
    rs2_data_i,
    flush_o
);

input rst_i;
input branch_i;
input [31:0] rs1_data_i;
input [31:0] rs2_data_i;
output reg flush_o;

always @(branch_i or rs1_data_i or rs2_data_i or negedge rst_i)
    if(~rst_i)
        flush_o = 0;
    else if (branch_i && (rs1_data_i == rs2_data_i))
        flush_o = 1;
    else
        flush_o = 0;

endmodule