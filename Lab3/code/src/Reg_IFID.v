module Reg_IFID (
    rst_i,
    clk_i,
    stall_i,
    flush_i,
    instr_addr_i,
    next_pc_i,
    instr_i,
    instr_addr_o,
    next_pc_o,
    instr_o,
);

input rst_i;
input clk_i;
input stall_i;
input flush_i;
input [31:0] instr_addr_i;
input [31:0] next_pc_i;
input [31:0] instr_i;
output reg [31:0] instr_addr_o;
output reg [31:0] next_pc_o;
output reg [31:0] instr_o;

always @(posedge clk_i or negedge rst_i)
    if (~rst_i || flush_i) begin
        instr_addr_o <= 32'b0;
        next_pc_o <= 32'b0;
        instr_o <= 32'b0;
    end else begin
        if (stall_i) begin
            instr_addr_o <= instr_addr_o;
            next_pc_o <= next_pc_o;
            instr_o <= instr_o;
        end else begin
            instr_addr_o <= instr_addr_i;
            next_pc_o <= next_pc_i;
            instr_o <= instr_i;
        end
    end
    
endmodule