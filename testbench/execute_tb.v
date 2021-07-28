`timescale 1ms/1ms

`include "../sources/stages/execute.v"
`include "../sources/memory/regFile.v"

module execute_tb();
	reg reset;

	// from decode
	reg [5:0] opcode;
	reg [3:0] rd;
	reg [3:0] rs;
	reg [3:0] rt;
	reg [3:0] cond;
	reg [17:0] imm;
	reg [21:0] md;
	reg is_alu_op;
	reg is_not_op;
	reg is_cmp_op;
	reg is_jmp_op;
	reg is_ld_op;
	reg is_str_op;
	reg is_call_op;
	reg is_ret_op;
	reg is_src2_imm;

	// to mem/wb
	wire [31:0] result;
	wire [31:0] cpsr_passthrough;
	wire taken;
	wire [31:0] pc_rel;
	wire [3:0] rd_num_passthrough;
	wire [31:0] rd_val_passthrough;
	wire [31:0] md_passthrough;
	wire is_alu_op_passthrough;
	wire is_cmp_op_passthrough;
	wire is_ld_op_passthrough;
	wire is_str_op_passthrough;

	// to regFile
	reg [31:0] if_pc_in;
	wire [31:0] if_pc_out;
	wire [3:0] exe_rd_num;
	wire [31:0] exe_rd_data_out;
	wire [3:0] exe_rs_num;
	wire [31:0] exe_rs_data_out;
	wire [3:0] exe_rt_num;
	wire [31:0] exe_rt_data_out;
	wire [31:0] exe_cpsr_out;
	reg [3:0] wb_rd_num;
	reg wb_rd_write_en;
	reg [31:0] wb_rd_in;
	reg wb_cpsr_write_en;
	reg [31:0] wb_cpsr_in;
`ifdef FOR_TEST
	wire [31:0] wb_rd_out;
	wire [31:0] wb_cpsr_out;
`endif

	integer i = 0;

	execute _execute(
		.opcode(opcode),
		.rd(rd),
		.rs(rs),
		.rt(rt),
		.cond(cond),
		.imm(imm),
		.md(md),
		.is_alu_op(is_alu_op),
		.is_not_op(is_not_op),
		.is_cmp_op(is_cmp_op),
		.is_jmp_op(is_jmp_op),
		.is_ld_op(is_ld_op),
		.is_str_op(is_str_op),
		.is_call_op(is_call_op),
		.is_ret_op(is_ret_op),
		.is_src2_imm(is_src2_imm),

		// to regFile
		.rd_num(exe_rd_num),
		.rd_val(exe_rd_data_out),
		.rs_num(exe_rs_num),
		.rs_val(exe_rs_data_out),
		.rt_num(exe_rt_num),
		.rt_val(exe_rt_data_out),

		// to mem/wb
		.result(result),
		.cpsr_passthrough(cpsr_passthrough),
		.cpsr_in(exe_cpsr_out),
		.taken(taken),
		.pc_rel(pc_rel),
		.rd_num_passthrough(rd_num_passthrough),
		.rd_val_passthrough(rd_val_passthrough),
		.md_passthrough(md_passthrough),
		.is_alu_op_passthrough(is_alu_op_passthrough),
		.is_cmp_op_passthrough(is_cmp_op_passthrough),
		.is_ld_op_passthrough(is_ld_op_passthrough),
		.is_str_op_passthrough(is_str_op_passthrough)
	);

	regFile _regFile(
		.reset(reset),
		.if_pc_in(if_pc_in),
		.if_pc_out(if_pc_out),
		.exe_rd_num(exe_rd_num),
		.exe_rd_data_out(exe_rd_data_out),
		.exe_rs_num(exe_rs_num),
		.exe_rs_data_out(exe_rs_data_out),
		.exe_rt_num(exe_rt_num),
		.exe_rt_data_out(exe_rt_data_out),
		.exe_cpsr_out(exe_cpsr_out),
		.wb_rd_num(wb_rd_num),
		.wb_rd_write_en(wb_rd_write_en),
		.wb_rd_in(wb_rd_in),
		.wb_cpsr_write_en(wb_cpsr_write_en),
		.wb_cpsr_in(wb_cpsr_in)
`ifdef FOR_TEST
		,
		.wb_rd_out(wb_rd_out),
		.wb_cpsr_out(wb_cpsr_out)
`endif
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _execute);
		$dumpvars(-1, _regFile);

		// initialize
		reset = 0;

		opcode = 0;
		rd = 0;
		rs = 0;
		rt = 0;
		cond = 0;
		imm = 0;
		md = 0;
		is_alu_op = 0;
		is_not_op = 0;
		is_cmp_op = 0;
		is_jmp_op = 0;
		is_ld_op = 0;
		is_str_op = 0;
		is_call_op = 0;
		is_ret_op = 0;
		is_src2_imm = 0;

		if_pc_in = 0;
		wb_rd_num = 0;
		wb_rd_write_en = 0;
		wb_rd_in = 0;
		wb_cpsr_write_en = 0;
		wb_cpsr_in = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

		// ADDrr, r1, r2, r3
		opcode <= 6'b001001; // resule = 0
		rd <= 4'd1;
		rs <= 4'd2;
		rt <= 4'd3;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd0;
		is_alu_op <= 1'b1;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// MOVrr, r4, r5
		opcode <= 6'b000000; // resule = 0
		rd <= 4'd4;
		rs <= 4'd5;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd0;
		is_alu_op <= 1'b1;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// MOVriLO16, r6, 7
		opcode <= 6'b000101; // resule = 7
		rd <= 4'd6;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd7;
		md <= 22'd0;
		is_alu_op <= 1'b1;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// MOVriHI16, r8, 9
		opcode <= 6'b000111; // resule = 0
		rd <= 4'd8;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd9;
		md <= 22'd0;
		is_alu_op <= 1'b1;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// NOTr, r10, r11
		opcode <= 6'b010100; // resule = 1
		rd <= 4'd10;
		rs <= 4'd11;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd0;
		is_alu_op <= 1'b1;
		is_not_op <= 1'b1;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// NOTi, r12, 1
		opcode <= 6'b010101; // resule = 0
		rd <= 4'd12;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd1;
		md <= 22'd0;
		is_alu_op <= 1'b1;
		is_not_op <= 1'b1;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// CMPrr, r2, r3
		opcode <= 6'b100000; // nzcv = 0100
		rd <= 4'd0;
		rs <= 4'd2;
		rt <= 4'd3;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd0;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b1;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// CMPri, r4, 5
		opcode <= 6'b100001; // nzcv = 1010 c?
		rd <= 4'd0;
		rs <= 4'd4;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd5;
		md <= 22'd0;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b1;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// JMP, 6
		opcode <= 6'b100010; // taken = 1, pc_rel = 6
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0000;
		imm <= 18'd0;
		md <= 22'd6;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// JEQ, 7
		opcode <= 6'b100011; // taken = 0
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0001;
		imm <= 18'd0;
		md <= 22'd7;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// JGE, 7
		opcode <= 6'b100011; // taken = 1, pc_rel = 7
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0010;
		imm <= 18'd0;
		md <= 22'd7;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// JGT, 7
		opcode <= 6'b100011; // taken = 1, pc_rel = 7
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0011;
		imm <= 18'd0;
		md <= 22'd7;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// JLE, 7
		opcode <= 6'b100011; // taken = 0
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0100;
		imm <= 18'd0;
		md <= 22'd7;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// JLT, 7
		opcode <= 6'b100011; // taken = 0
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0101;
		imm <= 18'd0;
		md <= 22'd7;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// JNE, 7
		opcode <= 6'b100011; // taken = 1, pc_rel = 7
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'b0110;
		imm <= 18'd0;
		md <= 22'd7;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b1;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// LD, r8, 9
		opcode <= 6'b100100; // is_str_op_passthrough = 1, rd_num_passthrough = 8, md_passthrough = 9
		rd <= 4'd8;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd9;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b1;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// STR, r10, 11
		opcode <= 6'b100101; // is_str_op_passthrough = 1, rd_val_passthrough = 0, md_passthrough = 11
		rd <= 4'd10;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd11;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b1;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b1;

		#1 reset = 0;
		#1 reset = 1;

		// CALL, r12
		opcode <= 6'b100110; // TODO:
		rd <= 4'd12;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd0;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b1;
		is_ret_op <= 1'b0;
		is_src2_imm <= 1'b0;

		#1 reset = 0;
		#1 reset = 1;

		// RET
		opcode <= 6'b100111; // TODO:
		rd <= 4'd0;
		rs <= 4'd0;
		rt <= 4'd0;
		cond <= 4'd0;
		imm <= 18'd0;
		md <= 22'd0;
		is_alu_op <= 1'b0;
		is_not_op <= 1'b0;
		is_cmp_op <= 1'b0;
		is_jmp_op <= 1'b0;
		is_ld_op <= 1'b0;
		is_str_op <= 1'b0;
		is_call_op <= 1'b0;
		is_ret_op <= 1'b1;
		is_src2_imm <= 1'b1;

		#1 $finish;
	end

endmodule