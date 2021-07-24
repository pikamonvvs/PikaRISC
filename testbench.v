`timescale 1ms/1ms

`include "top.v"

module testbench();
	reg clk;
	reg reset;

	PikaRISC _PikaRISC(clk, reset);

	initial begin
		$dumpfile("top.vcd");
		$dumpvars(-1, _PikaRISC);

		clk = 1;
		reset = 1;

		// reset
		#1 reset = 0;

		// clk
		repeat (20) begin
			#1 clk = ~clk;
		end

		$finish;
	end

endmodule // testbench