`ifndef __DECODE_V__
`define __DECODE_V__

`include "defines.v"

module decode(
	input	[31:0]	instruction,

	// fields
	output	[5:0]	opcode,
	output	[3:0]	rd,
	output	[3:0]	rs,
	output	[3:0]	rt,
	output	[3:0]	cond,
	output	[17:0]	imm,
	output	[21:0]	md,

	// flags
	output is_alu_op,
	output is_cmp_op,
	output is_jmp_op,
	output is_ld_op,
	output is_str_op,
	output is_call_op,
	output is_ret_op,
	output is_src2_imm
	);

	assign opcode	= instruction[31:26];
	assign rd		= instruction[25:22];
	assign rs		= instruction[21:18];
	assign rt		= instruction[17:14];
	assign cond		= instruction[25:22];
	assign imm		= instruction[17:0];
	assign md		= instruction[21:0];

	assign is_alu_op	= instruction[31:26] == `OP_ALU  ? 1'b1 : 1'b0;
	assign is_cmp_op	= instruction[31:26] == `OP_CMP  ? 1'b1 : 1'b0;
	assign is_jmp_op	= instruction[31:27] == `OP_JMP  ? 1'b1 : 1'b0;
	assign is_ld_op		= instruction[31:26] == `OP_LD   ? 1'b1 : 1'b0;
	assign is_str_op	= instruction[31:26] == `OP_STR  ? 1'b1 : 1'b0;
	assign is_call_op	= instruction[31:26] == `OP_CALL ? 1'b1 : 1'b0;
	assign is_ret_op	= instruction[31:26] == `OP_RET  ? 1'b1 : 1'b0;
	assign is_src2_imm	= instruction[26];

endmodule // decode

`endif /* __DECODE_V__ */