module Reg_EXMEM (
    rst_i,
    clk_i,
    regwrite_i,
    memtoreg_i,
    memread_i,
    memwrite_i,
    alu_result_i,
    rs2_data_i,
    rd_addr_i,
    regwrite_o,
    memtoreg_o,
    memread_o,
    memwrite_o,
    alu_result_o,
    rs2_data_o,
    rd_addr_o
);

// Inputs
input rst_i;
input clk_i;
input regwrite_i;
input memtoreg_i;
input memread_i;
input memwrite_i;
input [31:0] alu_result_i;
input [31:0] rs2_data_i;
input [4:0] rd_addr_i;

// Outputs
output reg regwrite_o;
output reg memtoreg_o;
output reg memread_o;
output reg memwrite_o;
output reg [31:0] alu_result_o;
output reg [31:0] rs2_data_o;
output reg [4:0] rd_addr_o;

always @(posedge clk_i or negedge rst_i)
    if (~rst_i) begin
        regwrite_o <= 1'b0;
        memtoreg_o <= 1'b0;
        memread_o <= 1'b0;
        memwrite_o <= 1'b0;
        alu_result_o <= 32'b0;
        rs2_data_o <= 32'b0;
        rd_addr_o <= 5'b0;
    end 
    else begin
        regwrite_o <= regwrite_i;
        memtoreg_o <= memtoreg_i;
        memread_o <= memread_i;
        memwrite_o <= memwrite_i;
        alu_result_o <= alu_result_i;
        rs2_data_o <= rs2_data_i;
        rd_addr_o <= rd_addr_i;
    end
    
endmodule