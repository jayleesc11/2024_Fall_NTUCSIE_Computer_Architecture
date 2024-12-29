module CPU
(
    rst_i,
    clk_i
);

// Ports
input               rst_i;
input               clk_i;

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(PC.pc_o + 4),
    .pc_o()
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o),
    .instr_o()
);

Control Control(
    .part_opcode_i(Instruction_Memory.instr_o[6:1]),
    .aluop_o(),
    .alusrc_o(),
    .regwrite_o()
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(Instruction_Memory.instr_o[19:15]),
    .RS2addr_i(Instruction_Memory.instr_o[24:20]),
    .RDaddr_i(Instruction_Memory.instr_o[11:7]),
    .RDdata_i(ALU.result_o),
    .RegWrite_i(Control.regwrite_o),
    .RS1data_o(),
    .RS2data_o()
);

MUX MUX_ALUSrc(
    .a_i(Registers.RS2data_o),
    .b_i(Sign_Extend.immext_o),
    .sel_i(Control.alusrc_o),
    .y_o()
);

Sign_Extend Sign_Extend(
    .imm_i(Instruction_Memory.instr_o[31:20]),
    .immext_o()
);
  
ALU ALU(
    .a_i(Registers.RS1data_o),
    .b_i(MUX_ALUSrc.y_o),
    .aluctr_i(ALU_Control.aluctr_o),
    .result_o(),
    .zero_o()
);

ALU_Control ALU_Control(
    .funct7_i(Instruction_Memory.instr_o[31:25]),
    .funct3_i(Instruction_Memory.instr_o[14:12]),
    .aluop_i(Control.aluop_o),
    .aluctr_o()
);

endmodule

