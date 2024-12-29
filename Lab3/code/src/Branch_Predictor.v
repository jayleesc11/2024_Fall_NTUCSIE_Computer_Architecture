module Branch_Predictor (
    clk_i,
    rst_i,
    id_branch_i,
    ex_branch_i,
    ex_taken_i,
    predict_o,
    id_flush_o,
    ex_flush_o,
    if_pcsrc_o
);

input clk_i;
input rst_i;
input id_branch_i;
input ex_branch_i;
input ex_taken_i;
output id_flush_o;
output ex_flush_o;
output predict_o;
output [1:0] if_pcsrc_o;

reg [1:0] cur_state;
reg [1:0] next_state;

assign ex_flush_o = ex_branch_i && (predict_o != ex_taken_i);
assign id_flush_o = ex_flush_o || (id_branch_i && predict_o);
assign predict_o = ~cur_state[1];
assign if_pcsrc_o = ex_flush_o ? 2'b10 : (id_flush_o ? 2'b01 : 2'b00);

always @(posedge clk_i or negedge rst_i)
    if (~rst_i) begin
        cur_state = 2'b00;
        next_state = 2'b00;
    end else if (ex_branch_i)
        case (cur_state)
            2'b00: next_state = ex_taken_i ? 2'b00 : 2'b01;
            2'b01: next_state = ex_taken_i ? 2'b00 : 2'b10;
            2'b10: next_state = ex_taken_i ? 2'b01 : 2'b11;
            2'b11: next_state = ex_taken_i ? 2'b10 : 2'b11;
            default: next_state = 2'b00;
        endcase
    else
        next_state = cur_state;

always @(posedge clk_i)
    cur_state <= next_state;
    
endmodule