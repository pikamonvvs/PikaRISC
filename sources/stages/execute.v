`ifndef __EXECUTE_V__
`define __EXECUTE_V__

`include "signExtend.v"
`include "alu.v"
`include "condChecker.v"

module execute(
	// fields
	input [5:0] opcode,
	input [3:0] rd, rs, rt, cond,
	input [17:0] imm,
	input [21:0] md,

	// flags
	input is_alu_op,
	input is_cmp_op,
	input is_jmp_op,
	input is_ld_op,
	input is_str_op,
	input is_call_op,
	input is_ret_op,
	input is_src2_imm,

	// to regFile
	output [3:0] rd_num, //
	output [3:0] rs_num,
	output [3:0] rt_num,
	input [31:0] rd_val, //
	input [31:0] rs_val,
	input [31:0] rt_val,

	// to alu
	output [31:0] result,
	// to comparator
	output [31:0] cpsr_out,
	// to condChecker
	input [31:0] cpsr_in, // TODO:
	output taken,

	// pass-through
	output [3:0] rd_num_passthrough, // alu
	output [31:0] rd_val_passthrough, // alu
	output [31:0] md_passthrough,
	output is_alu_op_passthrough,
	output is_cmp_op_passthrough,
	output is_jmp_op_passthrough,
	output is_ld_op_passthrough,
	output is_str_op_passthrough
	);

	wire [31:0] val1, val2;
	wire [31:0] imm32;
	wire [31:0] md32;
	wire [3:0] nzcv;

	// TODO: postition of operand differ according to instruction
	assign rs_num = rs;
	assign rt_num = (!is_src2_imm) ? rt_num : 0;
	assign val1 = rs_val;
	assign val2 = (!is_src2_imm) ? rt_val : imm32;

	assign rd_num = rd;		// need to pass for ld
	assign val0 = rd_val;	// need to pass for str

	assign cpsr_out = { 28'd0, nzcv };

	signExtendImm _signExtendImm(
		.in(imm),
		.out(imm32)
	);

	signExtendMd _signExtendMd(
		.in(md),
		.out(md32)
	);

	// alu
	wire [4:0] aluop;
	assign aluop = (is_alu_op) ? opcode[5:1] : 0;
	alu _alu(
		.is_alu_op(is_alu_op),
		.val1(val1),
		.val2(val2),
		.aluop(aluop),
		.result(result)
	);

	// compare
	comparator _comparator(
		.is_cmp_op(is_cmp_op),
		.val1(val1),
		.val2(val2), // TODO: rr ri
		.nzcv(nzcv)
	);

	// branch
	condChecker _condChecker(
		.is_jmp_op(is_jmp_op),
		.cpsr_in(cpsr_in[3:0]),
		.cond(cond),
		.taken(taken)
	);

	// taken(pcWrite, if is_jmp_op && taken ? pc<-{10'd0, md}), nzcv(cpsr to write, if is_cmp_op ? regWrite <- nzcv), result(regWrite, if is_alu_op ? regaddr[rd] <- result; regWEn <- 1)
	assign rd_num_passthrough = rd;
	assign rd_val_passthrough = val0;
	assign md_passthrough = md32;
	assign is_alu_op_passthrough = is_alu_op;
	assign is_cmp_op_passthrough = is_cmp_op;
	assign is_jmp_op_passthrough = is_jmp_op;
	assign is_ld_op_passthrough = is_ld_op;
	assign is_str_op_passthrough = is_str_op;

	// etc // TODO: ld str call ret

endmodule // execute

`endif /* __EXECUTE_V__ */