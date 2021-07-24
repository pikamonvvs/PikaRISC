`ifndef __TOP_V__
`define __TOP_V__

`include "sources/memory/regFile.v"

`include "sources/stages/fetch.v"
`include "sources/stages/decode.v"
`include "sources/stages/execute.v"
`include "sources/stages/memory.v"
`include "sources/stages/writeback.v"

module PikaRISC(
	input clk,
	input reset,

	// to instrMem
	output [31:0] imem_addr,
	input [31:0] imem_data,

	// to dataMem
	output [31:0] dmem_addr,
	output dmem_write_en,
	output [31:0] dmem_val_out,
	input [31:0] dmem_val_in
	);

	// regFile
	wire [31:0] if_pc_in;
	wire [31:0] if_pc_out;
	wire [3:0] exe_rd_num;
	wire [31:0] exe_rd_data_out;
	wire [3:0] exe_rs_num;
	wire [31:0] exe_rs_data_out;
	wire [3:0] exe_rt_num;
	wire [31:0] exe_rt_data_out;
	wire [31:0] exe_cpsr_out;
	wire [3:0] wb_rd_num;
	wire wb_rd_write_en;
	wire [31:0] wb_rd_in;
	wire wb_pc_write_en;
	wire [31:0] wb_pc_in;
	wire wb_cpsr_write_en;
	wire [31:0] wb_cpsr_in;

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
		.wb_pc_write_en(wb_pc_write_en),
		.wb_pc_in(wb_pc_in),
		.wb_cpsr_write_en(wb_cpsr_write_en),
		.wb_cpsr_in(wb_cpsr_in)
	);

	// stages
	wire [31:0] instruction;
	wire taken;

	fetch _fetch(
		.instruction(instruction),
		.imem_addr(imem_addr),	//
		.imem_data(imem_data),	//
		.pc_in(if_pc_out),		//
		.pc_out(if_pc_in),		//
		.taken(taken)
	);

	wire [5:0] opcode;
	wire [3:0] rd;
	wire [3:0] rs;
	wire [3:0] rt;
	wire [3:0] cond;
	wire [17:0] imm;
	wire [21:0] md;
	wire is_alu_op;
	wire is_cmp_op;
	wire is_jmp_op;
	wire is_ld_op;
	wire is_str_op;
	wire is_call_op;
	wire is_ret_op;
	wire is_src2_imm;

	decode _decode(
		.instruction(instruction),
		.opcode(opcode),
		.rd(rd),
		.rs(rs),
		.rt(rt),
		.cond(cond),
		.imm(imm),
		.md(md),
		.is_alu_op(is_alu_op),
		.is_cmp_op(is_cmp_op),
		.is_jmp_op(is_jmp_op),
		.is_ld_op(is_ld_op),
		.is_str_op(is_str_op),
		.is_call_op(is_call_op),
		.is_ret_op(is_ret_op),
		.is_src2_imm(is_src2_imm)
	);

	wire [31:0] result;
	wire [31:0] cpsr_passthrough;
	wire [3:0] rd_num_passthrough;
	wire [31:0] rd_val_passthrough;
	wire [31:0] md_passthrough;
	wire is_alu_op_passthrough;
	wire is_cmp_op_passthrough;
	wire is_jmp_op_passthrough;
	wire is_ld_op_passthrough;
	wire is_str_op_passthrough;

	execute _execute(
		.opcode(opcode),
		.rd(rd),
		.rs(rs),
		.rt(rt),
		.cond(cond),
		.imm(imm),
		.md(md),
		.is_alu_op(is_alu_op),
		.is_cmp_op(is_cmp_op),
		.is_jmp_op(is_jmp_op),
		.is_ld_op(is_ld_op),
		.is_str_op(is_str_op),
		.is_call_op(is_call_op),
		.is_ret_op(is_ret_op),
		.is_src2_imm(is_src2_imm),
		.rd_num(exe_rd_num),					//
		.rd_val(exe_rd_data_out),				//
		.rs_num(exe_rs_num),					//
		.rs_val(exe_rs_data_out),				//
		.rt_num(exe_rt_num),					//
		.rt_val(exe_rt_data_out),				//
		.result(result),
		.cpsr_passthrough(cpsr_passthrough),
		.cpsr_in(exe_cpsr_out),					//
		.taken(taken),
		.rd_num_passthrough(rd_num_passthrough),
		.rd_val_passthrough(rd_val_passthrough),
		.md_passthrough(md_passthrough),
		.is_alu_op_passthrough(is_alu_op_passthrough),
		.is_cmp_op_passthrough(is_cmp_op_passthrough),
		.is_jmp_op_passthrough(is_jmp_op_passthrough),
		.is_ld_op_passthrough(is_ld_op_passthrough),
		.is_str_op_passthrough(is_str_op_passthrough)
	);

	wire reg [31:0] dmem_val_passthrough;

	memory _memory(
		.md_passthrough(md_passthrough),
		.rd_val_passthrough(rd_val_passthrough),
		.dmem_val_passthrough(dmem_val_passthrough),
		.is_ld_op_passthrough(is_ld_op_passthrough),
		.is_str_op_passthrough(is_str_op_passthrough),
		.dmem_addr(dmem_addr),			//
		.dmem_write_en(dmem_write_en),	//
		.dmem_val_out(dmem_val_out),	//
		.dmem_val_in(dmem_val_in)		//
	);

	writeback _writeback(
		.rd_num_passthrough(rd_num_passthrough),
		.md_passthrough(md_passthrough),
		.result(result),
		.cpsr_passthrough(cpsr_passthrough),
		.dmem_val_passthrough(dmem_val_passthrough),
		.taken(taken),
		.is_alu_op_passthrough(is_alu_op_passthrough),
		.is_cmp_op_passthrough(is_cmp_op_passthrough),
		.is_jmp_op_passthrough(is_jmp_op_passthrough),
		.is_ld_op_passthrough(is_ld_op_passthrough),
		.rd_num(wb_rd_num),					//
		.rd_write_en(wb_rd_write_en),		//
		.rd_val(wb_rd_in),					//
		.pc_write_en(wb_pc_write_en),		//
		.pc_out(wb_pc_in),					//
		.cpsr_write_en(wb_cpsr_write_en),	//
		.cpsr_out(wb_cpsr_in)				//
	);

endmodule // PikaRISC

`endif /*__TOP_V__*/