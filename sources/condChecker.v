`ifndef __CONDCHECKER_V__
`define __CONDCHECKER_V__

`include "defines.v"

module condChecker(
	input [3:0] cpsr_in,
	input [3:0] cond,
	input is_jmp_op,
	output reg taken // FIXME:
	);

	wire n, z, c, v;

	always @ (*) begin
		if (is_jmp_op) begin
			case (cond)
				`COND_JMP: taken <= 1'b1;
				`COND_JEQ: taken <= (z == 1) ? 1'b1 : 1'b0;
				`COND_JGE: taken <= (n == v) ? 1'b1 : 1'b0;
				`COND_JGT: taken <= (z == 0 && n == v) ? 1'b1 : 1'b0;
				`COND_JLE: taken <= (z == 1 || n != v) ? 1'b1 : 1'b0;
				`COND_JLT: taken <= (n != v) ? 1'b1 : 1'b0;
				`COND_JNE: taken <= (z == 0) ? 1'b1 : 1'b0;
				default: taken <= 1'b0;
			endcase
		end
	end

	assign n = cpsr_in[3];
	assign z = cpsr_in[2];
	assign c = cpsr_in[1];
	assign v = cpsr_in[0];

endmodule // condChecker

`endif /*__CONDCHECKER_V__*/