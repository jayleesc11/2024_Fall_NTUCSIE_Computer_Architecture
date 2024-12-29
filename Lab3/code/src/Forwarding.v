module Forwarding (
    ex_rs1_addr_i,
    ex_rs2_addr_i,
    mem_regwrite_i,
    mem_rd_addr_i,
    wb_regwrite_i,
    wb_rd_addr_i,
    forward_a_o,
    forward_b_o
);

input [4:0] ex_rs1_addr_i;
input [4:0] ex_rs2_addr_i;
input mem_regwrite_i;
input [4:0] mem_rd_addr_i;
input wb_regwrite_i;
input [4:0] wb_rd_addr_i;
output reg [1:0] forward_a_o;
output reg [1:0] forward_b_o;

wire mem_valid_regwrite;
wire wb_valid_regwrite;

assign mem_valid_regwrite = mem_regwrite_i && (mem_rd_addr_i != 0);
assign wb_valid_regwrite = wb_regwrite_i && (wb_rd_addr_i != 0);

always @(*) begin
    if(mem_valid_regwrite && (mem_rd_addr_i == ex_rs1_addr_i))
        forward_a_o = 2'b10;
    else if(wb_valid_regwrite && (wb_rd_addr_i == ex_rs1_addr_i))
        forward_a_o = 2'b01;
    else
        forward_a_o = 2'b00;
    
    if(mem_valid_regwrite && (mem_rd_addr_i == ex_rs2_addr_i))
        forward_b_o = 2'b10;
    else if(wb_valid_regwrite && (wb_rd_addr_i == ex_rs2_addr_i))
        forward_b_o = 2'b01;
    else 
        forward_b_o = 2'b00;
end

endmodule