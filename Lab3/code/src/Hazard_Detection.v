module Hazard_Detection (
    ex_memread_i,
    ex_rd_addr_i,
    rs1_addr_i,
    rs2_addr_i,
    no_op_o,
    stall_o,
    pcwrite_o
);

input ex_memread_i;
input [4:0] ex_rd_addr_i;
input [4:0] rs1_addr_i;
input [4:0] rs2_addr_i;
output reg no_op_o;
output reg stall_o;
output reg pcwrite_o;

always @(*)
    if(ex_memread_i && ex_rd_addr_i != 0 && (ex_rd_addr_i == rs1_addr_i || ex_rd_addr_i == rs2_addr_i)) begin
        stall_o = 1;
        no_op_o = 1;
        pcwrite_o = 0;
    end else begin
        stall_o = 0;
        no_op_o = 0;
        pcwrite_o = 1;
    end
    
endmodule