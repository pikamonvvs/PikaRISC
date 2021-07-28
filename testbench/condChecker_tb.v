`timescale 1ms/1ms

`include "../sources/condChecker.v"
`include "../sources/defines.v"

module condChecker_tb();
	reg [3:0] cpsr_in;
	reg [3:0] cond;
	reg is_jmp_op;
	wire taken;

	condChecker _condChecker(
		.cpsr_in(cpsr_in),
		.cond(cond),
		.is_jmp_op(is_jmp_op),
		.taken(taken)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _condChecker);

		is_jmp_op <= 1;

		// JMP ok
		#1 cond <= `COND_JMP;
		   cpsr_in <= 4'b0000; // taken
		#1 cpsr_in <= 4'b1111; // taken

		// JEQ
		#1 cond <= `COND_JEQ;
		   cpsr_in <= 4'b0000; // not taken
		#1 cpsr_in <= 4'b1111; // taken
		#1 cpsr_in <= 4'b1011; // not taken
		#1 cpsr_in <= 4'b0100; // taken

		// JGE
		#1 cond <= `COND_JGE;
		   cpsr_in <= 4'b0000; // taken
		#1 cpsr_in <= 4'b1111; // taken
		#1 cpsr_in <= 4'b1001; // taken
		#1 cpsr_in <= 4'b0110; // taken
		#1 cpsr_in <= 4'b1100; // not taken
		#1 cpsr_in <= 4'b0011; // not taken

		// JGT
		#1 cond <= `COND_JGT;
		   cpsr_in <= 4'b0000; // taken
		#1 cpsr_in <= 4'b1111; // not taken
		#1 cpsr_in <= 4'b1001; // taken
		#1 cpsr_in <= 4'b1011; // taken
		#1 cpsr_in <= 4'b1100; // not taken
		#1 cpsr_in <= 4'b0010; // taken

		// JLE
		#1 cond <= `COND_JLE;
		   cpsr_in <= 4'b0000; // not taken
		#1 cpsr_in <= 4'b1111; // taken
		#1 cpsr_in <= 4'b0100; // taken
		#1 cpsr_in <= 4'b1011; // not taken
		#1 cpsr_in <= 4'b0010; // not taken
		#1 cpsr_in <= 4'b1100; // taken

		// JLT ok
		#1 cond <= `COND_JLT;
		   cpsr_in <= 4'b0000; // not taken
		#1 cpsr_in <= 4'b1111; // not taken
		#1 cpsr_in <= 4'b1100; // taken
		#1 cpsr_in <= 4'b0011; // taken
		#1 cpsr_in <= 4'b1010; // taken
		#1 cpsr_in <= 4'b0101; // taken

		// JNE ok
		#1 cond <= `COND_JNE;
		   cpsr_in <= 4'b0000; // taken
		#1 cpsr_in <= 4'b1111; // not taken
		#1 cpsr_in <= 4'b1011; // taken
		#1 cpsr_in <= 4'b0100; // not taken


		#1 $finish;
	end

endmodule
