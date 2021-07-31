`ifndef __ALU_V__
`define __ALU_V__

`include "defines.v"

module alu(
	input [31:0] val1,
	input [31:0] val2,
	input [4:0] aluop,
	input is_alu_op,
	output reg [31:0] result // FIXME:
	);

	initial begin
		result <= 0;
	end

	always @ (*) begin
		if (is_alu_op) begin
			case (aluop)
				`ALUOP_MOV:  result <= val1;
				`ALUOP_MOVL: result <= { 16'd0, val2[15:0] };
				`ALUOP_MOVH: result <= { 16'd0, val2[31:16] };

				`ALUOP_ADD:  result <= val1 + val2;
				`ALUOP_SUB:  result <= val1 - val2;
				`ALUOP_MUL:  result <= val1 * val2;
				`ALUOP_DIV:  result <= val1 / val2;

				`ALUOP_AND:  result <= val1 & val2;
				`ALUOP_OR :  result <= val1 | val2;
				`ALUOP_NOT:  result <= !val1;
				`ALUOP_XOR:  result <= val1 ^ val2;

				`ALUOP_SHL:  result <= val1 << val2;
				`ALUOP_SHR:  result <= val1 >> val2;
				`ALUOP_ASR:  result <= val1 >>> val2;

				default: result <= 0;
			endcase
		end
		else begin
			result <= 0;
		end
	end

endmodule // alu

`endif /*__ALU_V__*/