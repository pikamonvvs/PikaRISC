`timescale 1ms/1ms

`include "alu.v"
`include "defines.v"
//`include "../sources/alu.v"
//`include "../sources/defines.v"

module alu_tb();
	reg [31:0] val1;
	reg [31:0] val2;
	reg [4:0] aluop;
	reg is_alu_op;
	wire [31:0] result;

	alu _alu(
		.val1(val1),
		.val2(val2),
		.aluop(aluop),
		.is_alu_op(is_alu_op),
		.result(result)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _alu);

		is_alu_op <= 1;
		val1 <= 32'd8;
		val2 <= 32'd8;

		#1 aluop <= `ALUOP_MOV;  // 0, 0x8   ok
		#1 aluop <= `ALUOP_MOVL; // 2, 0x8   ok
		#1 aluop <= `ALUOP_MOVH; // 3, 0x0   ok
		#1 aluop <= `ALUOP_ADD;  // 4, 0x10  ok
		#1 aluop <= `ALUOP_SUB;  // 5, 0x0   ok
		#1 aluop <= `ALUOP_MUL;  // 6, 0x40  ok
		#1 aluop <= `ALUOP_DIV;  // 7, 0x1   ok
		#1 aluop <= `ALUOP_AND;  // 8, 0x8   ok
		#1 aluop <= `ALUOP_OR ;  // 9, 0x8   ok
		#1 aluop <= `ALUOP_NOT;  // A, 0x0   ok
		#1 aluop <= `ALUOP_XOR;  // B, 0x0   ok
		#1 aluop <= `ALUOP_SHL;  // C, 0x800 ok
		#1 aluop <= `ALUOP_SHR;  // D, 0x0   ok
		#1 aluop <= `ALUOP_ASR;  // E, 0x0   ok

		#1 $finish;
	end

endmodule
