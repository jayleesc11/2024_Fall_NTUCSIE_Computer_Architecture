module CPU (
    rst_i,
    clk_i
);

// Ports
input       rst_i;
input       clk_i;

// Components
Hazard_Detection Hazard_Detection(
    .ex_memread_i(Reg_IDEX.memread_o),
    .ex_rd_addr_i(Reg_IDEX.rd_addr_o),
    .rs1_addr_i(Reg_IFID.instr_o[19:15]),
    .rs2_addr_i(Reg_IFID.instr_o[24:20]),
    .no_op_o(),
    .stall_o(),
    .pcwrite_o()
);

Flush Flush(
    .rst_i(rst_i),
    .branch_i(Control.branch_o),
    .rs1_data_i(Registers.RS1data_o),
    .rs2_data_i(Registers.RS2data_o),
    .flush_o()
);

MUX MUX_PCSrc(
    .a_i(PC.pc_o + 4),
    .b_i(Reg_IFID.instr_addr_o + (Imm_Gen.immext_o << 1)),
    .sel_i(Flush.flush_o),
    .y_o()
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(Hazard_Detection.pcwrite_o),
    .pc_i(MUX_PCSrc.y_o),
    .pc_o()
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o),
    .instr_o()
);

Reg_IFID Reg_IFID(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .stall_i(Hazard_Detection.stall_o),
    .flush_i(Flush.flush_o),
    .instr_addr_i(PC.pc_o),
    .instr_i(Instruction_Memory.instr_o),
    .instr_addr_o(),
    .instr_o()
);

Control Control(
    .no_op_i(Hazard_Detection.no_op_o),
    .part_opcode_i(Reg_IFID.instr_o[6:1]),
    .regwrite_o(),
    .memtoreg_o(),
    .memread_o(),
    .memwrite_o(),
    .aluop_o(),
    .alusrc_o(),
    .branch_o()
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(Reg_IFID.instr_o[19:15]),
    .RS2addr_i(Reg_IFID.instr_o[24:20]),
    .RDaddr_i(Reg_MEMWB.rd_addr_o),
    .RDdata_i(MUX_MemtoReg.y_o),
    .RegWrite_i(Reg_MEMWB.regwrite_o),
    .RS1data_o(),
    .RS2data_o()
);

Imm_Gen Imm_Gen(
    .instr_i(Reg_IFID.instr_o),
    .immext_o()
);

Reg_IDEX Reg_IDEX(
    // inputs
    .rst_i(rst_i),
    .clk_i(clk_i),
    .regwrite_i(Control.regwrite_o),
    .memtoreg_i(Control.memtoreg_o),
    .memread_i(Control.memread_o),
    .memwrite_i(Control.memwrite_o),
    .aluop_i(Control.aluop_o),
    .alusrc_i(Control.alusrc_o),
    .rs1_data_i(Registers.RS1data_o),
    .rs2_data_i(Registers.RS2data_o),
    .immext_i(Imm_Gen.immext_o),
    .funct7_i(Reg_IFID.instr_o[31:25]),
    .funct3_i(Reg_IFID.instr_o[14:12]),
    .rs1_addr_i(Reg_IFID.instr_o[19:15]),
    .rs2_addr_i(Reg_IFID.instr_o[24:20]),
    .rd_addr_i(Reg_IFID.instr_o[11:7]),
    // outputs
    .regwrite_o(),
    .memtoreg_o(),
    .memread_o(),
    .memwrite_o(),
    .aluop_o(),
    .alusrc_o(),
    .rs1_data_o(),
    .rs2_data_o(),
    .immext_o(),
    .funct7_o(),
    .funct3_o(),
    .rs1_addr_o(),
    .rs2_addr_o(),
    .rd_addr_o()
);

Forwarding Forwarding(
    .ex_rs1_addr_i(Reg_IDEX.rs1_addr_o),
    .ex_rs2_addr_i(Reg_IDEX.rs2_addr_o),
    .mem_regwrite_i(Reg_EXMEM.regwrite_o),
    .mem_rd_addr_i(Reg_EXMEM.rd_addr_o),
    .wb_regwrite_i(Reg_MEMWB.regwrite_o),
    .wb_rd_addr_i(Reg_MEMWB.rd_addr_o),
    .forward_a_o(),
    .forward_b_o()
);

MUX_4Way MUX_ForwardA(
    .a_i(Reg_IDEX.rs1_data_o),
    .b_i(MUX_MemtoReg.y_o),
    .c_i(Reg_EXMEM.alu_result_o),
    .d_i(32'b0),
    .sel_i(Forwarding.forward_a_o),
    .y_o()
);

MUX_4Way MUX_ForwardB(
    .a_i(Reg_IDEX.rs2_data_o),
    .b_i(MUX_MemtoReg.y_o),
    .c_i(Reg_EXMEM.alu_result_o),
    .d_i(32'b0),
    .sel_i(Forwarding.forward_b_o),
    .y_o()
);

MUX MUX_ALUsrc(
    .a_i(MUX_ForwardB.y_o),
    .b_i(Reg_IDEX.immext_o),
    .sel_i(Reg_IDEX.alusrc_o),
    .y_o()
);

ALU_Control ALU_Control(
    .funct3_i(Reg_IDEX.funct3_o),
    .funct7_i(Reg_IDEX.funct7_o),
    .aluop_i(Reg_IDEX.aluop_o),
    .aluctr_o()
);

ALU ALU(
    .a_i(MUX_ForwardA.y_o),
    .b_i(MUX_ALUsrc.y_o),
    .aluctr_i(ALU_Control.aluctr_o),
    .result_o()
);

Reg_EXMEM Reg_EXMEM(
    // inputs
    .rst_i(rst_i),
    .clk_i(clk_i),
    .regwrite_i(Reg_IDEX.regwrite_o),
    .memtoreg_i(Reg_IDEX.memtoreg_o),
    .memread_i(Reg_IDEX.memread_o),
    .memwrite_i(Reg_IDEX.memwrite_o),
    .alu_result_i(ALU.result_o),
    .rs2_data_i(MUX_ForwardB.y_o),
    .rd_addr_i(Reg_IDEX.rd_addr_o),
    // outputs
    .regwrite_o(),
    .memtoreg_o(),
    .memread_o(),
    .memwrite_o(),
    .alu_result_o(),
    .rs2_data_o(),
    .rd_addr_o()
);

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(Reg_EXMEM.alu_result_o),
    .MemRead_i(Reg_EXMEM.memread_o),
    .MemWrite_i(Reg_EXMEM.memwrite_o),
    .data_i(Reg_EXMEM.rs2_data_o),
    .data_o()
);

Reg_MEMWB Reg_MEMWB(
    // inputs
    .rst_i(rst_i),
    .clk_i(clk_i),
    .regwrite_i(Reg_EXMEM.regwrite_o),
    .memtoreg_i(Reg_EXMEM.memtoreg_o),
    .alu_result_i(Reg_EXMEM.alu_result_o),
    .memdata_i(Data_Memory.data_o),
    .rd_addr_i(Reg_EXMEM.rd_addr_o),
    // outputs
    .regwrite_o(),
    .memtoreg_o(),
    .alu_result_o(),
    .memdata_o(),
    .rd_addr_o()
);

MUX MUX_MemtoReg(
    .sel_i(Reg_MEMWB.memtoreg_o),
    .a_i(Reg_MEMWB.alu_result_o),
    .b_i(Reg_MEMWB.memdata_o),
    .y_o()
);

endmodule