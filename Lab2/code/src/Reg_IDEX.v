module Reg_IDEX (
    rst_i,
    clk_i,
    regwrite_i,
    memtoreg_i,
    memread_i,
    memwrite_i,
    aluop_i,
    alusrc_i,
    rs1_data_i,
    rs2_data_i,
    immext_i,
    funct7_i,
    funct3_i,
    rs1_addr_i,
    rs2_addr_i,
    rd_addr_i,
    regwrite_o,
    memtoreg_o,
    memread_o,
    memwrite_o,
    aluop_o,
    alusrc_o,
    rs1_data_o,
    rs2_data_o,
    immext_o,
    funct7_o,
    funct3_o,
    rs1_addr_o,
    rs2_addr_o,
    rd_addr_o
);

// Inputs
input rst_i;
input clk_i;
input regwrite_i;
input memtoreg_i;
input memread_i;
input memwrite_i;
input [1:0] aluop_i;
input alusrc_i;
input [31:0] rs1_data_i;
input [31:0] rs2_data_i;
input [31:0] immext_i;
input [6:0] funct7_i;
input [2:0] funct3_i;
input [4:0] rs1_addr_i;
input [4:0] rs2_addr_i;
input [4:0] rd_addr_i;

// Outputs
output reg regwrite_o;
output reg memtoreg_o;
output reg memread_o;
output reg memwrite_o;
output reg [1:0] aluop_o;
output reg alusrc_o;
output reg [31:0] rs1_data_o;
output reg [31:0] rs2_data_o;
output reg [31:0] immext_o;
output reg [6:0] funct7_o;
output reg [2:0] funct3_o;
output reg [4:0] rs1_addr_o;
output reg [4:0] rs2_addr_o;
output reg [4:0] rd_addr_o;

always @(posedge clk_i or negedge rst_i)
    if (~rst_i) begin
        regwrite_o <= 1'b0;
        memtoreg_o <= 1'b0;
        memread_o <= 1'b0;
        memwrite_o <= 1'b0;
        aluop_o <= 2'b00;
        alusrc_o <= 1'b0;
        rs1_data_o <= 32'b0;
        rs2_data_o <= 32'b0;
        immext_o <= 32'b0;
        funct7_o <= 7'b0;
        funct3_o <= 3'b0;
        rs1_addr_o <= 5'b0;
        rs2_addr_o <= 5'b0;
        rd_addr_o <= 5'b0;
    end else begin
        regwrite_o <= regwrite_i;
        memtoreg_o <= memtoreg_i;
        memread_o <= memread_i;
        memwrite_o <= memwrite_i;
        aluop_o <= aluop_i;
        alusrc_o <= alusrc_i;
        rs1_data_o <= rs1_data_i;
        rs2_data_o <= rs2_data_i;
        immext_o <= immext_i;
        funct7_o <= funct7_i;
        funct3_o <= funct3_i;
        rs1_addr_o <= rs1_addr_i;
        rs2_addr_o <= rs2_addr_i;
        rd_addr_o <= rd_addr_i;
    end
    
endmodule