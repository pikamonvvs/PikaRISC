`timescale 1ms/1ms

`include "../sources/comparator.v"

module comparator_tb();
	reg [31:0] val1;
	reg [31:0] val2;
	reg is_cmp_op;
	wire [3:0] nzcv;

	comparator _comparator(
		.val1(val1),
		.val2(val2),
		.is_cmp_op(is_cmp_op),
		.nzcv(nzcv)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _comparator);

		is_cmp_op <= 1;

		// 0x0
		#1 val1 <= 32'h0;
		   val2 <= 32'h0;        // 0100 4
		#1 val2 <= 32'h7fffffff; // 1000 8 A?
		#1 val2 <= 32'h80000000; // 1001 9
		#1 val2 <= 32'hffffffff; // 0000 0

		// 0x0fffffff
		#1 val1 <= 32'h7fffffff;
		   val2 <= 32'h0;        // 0000 0
		#1 val2 <= 32'h7fffffff; // 0100 4
		#1 val2 <= 32'h80000000; // 1001 9
		#1 val2 <= 32'hffffffff; // 1001 9

		// 0x10000000
		#1 val1 <= 32'h80000000;
		   val2 <= 32'h0;        // 1000 8 A?
		#1 val2 <= 32'h7fffffff; // 0011 3
		#1 val2 <= 32'h80000000; // 0100 4
		#1 val2 <= 32'hffffffff; // 1000 8 A?

		// 0xffffffff
		#1 val1 <= 32'hffffffff;
		   val2 <= 32'h0;        // 1000 8 A?
		#1 val2 <= 32'h7fffffff; // 1010 A
		#1 val2 <= 32'h80000000; // 0011 3 0?
		#1 val2 <= 32'hffffffff; // 0100 4

		#1 $finish;
	end

endmodule