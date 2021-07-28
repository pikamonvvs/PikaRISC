`timescale 1ms/1ms

`include "../sources/stages/decode.v"

module decode_tb();
	reg [31:0] instruction;
	wire [5:0] opcode;
	wire [3:0] rd;
	wire [3:0] rs;
	wire [3:0] rt;
	wire [3:0] cond;
	wire [17:0] imm;
	wire [21:0] md;
	wire is_alu_op;
	wire is_not_op;
	wire is_cmp_op;
	wire is_jmp_op;
	wire is_ld_op;
	wire is_str_op;
	wire is_call_op;
	wire is_ret_op;
	wire is_src2_imm;

	integer i = 0;

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
		.is_not_op(is_not_op),
		.is_cmp_op(is_cmp_op),
		.is_jmp_op(is_jmp_op),
		.is_ld_op(is_ld_op),
		.is_str_op(is_str_op),
		.is_call_op(is_call_op),
		.is_ret_op(is_ret_op),
		.is_src2_imm(is_src2_imm)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _decode);

		// R-type
		instruction <= 32'b001000_0010_0011_0100_00000000000000; // ADDrr r2, r3, r4

		// I-type
		#1 instruction <= 32'b010001_0101_0110_000000000000000111; // ANDri r5, r6, 0x7

		// CR-type
		#1 instruction <= 32'b100000_0000_1000_1001_00000000000000; // CMPrr r8, r9

		// J-type
		#1 instruction <= 32'b100011_0001_0000000000000000001010; // JEQ 0xA

		// M-type
		#1 instruction <= 32'b100100_1011_0000000000000000001100; // LD r11, 0xC
		#1 instruction <= 32'b100101_1101_0000000000000000001110; // STR r13, 0xE

		// P-type
		#1 instruction <= 32'b100110_0000_0000000000000000001111; // CALL 0xF
		#1 instruction <= 32'b100111_00000000000000000000000000; // RET

		// Unary operation
		#1 instruction <= 32'b000101_0001_0000_000000000000010000; // MOVriLO16 r1, 0x10
		#1 instruction <= 32'b000111_0010_0000_000000000000010001; // MOVriHI16 r2, 0x11
		#1 instruction <= 32'b010100_0011_0100_000000000000000000; // NOTr r3, r4
		#1 instruction <= 32'b010101_0101_0000_000000000000010010; // NOTi r5, 0x12

		#1 $finish;
	end

endmodule