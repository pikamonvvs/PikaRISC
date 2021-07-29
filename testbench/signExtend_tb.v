`timescale 1ms/1ms

`include "../sources/signExtend.v"

module signExtend_tb();
	reg [17:0] in1;
	wire [31:0] out1;
	reg [21:0] in2;
	wire [31:0] out2;

	integer i = 0;

	signExtendImm _signExtendImm(
		.in(in1),
		.out(out1)
	);

	signExtendMd _signExtendMd(
		.in(in2),
		.out(out2)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _signExtendImm);
		$dumpvars(-1, _signExtendMd);

		// imm
		for (i = 0; i < 256; i = i + 1) begin
			#1 in1 <= i; // out1
		end

		// mem
		for (i = 0; i < 256; i = i + 1) begin
			#1 in2 <= i; // out2
		end

		#1 $finish;
	end

endmodule
