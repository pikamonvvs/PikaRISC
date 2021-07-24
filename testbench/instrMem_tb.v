`timescale 1ns/1ns

`include "instrMem.v"

module instrMem_tb();
	reg reset;
	reg [21:0] address;
	wire [31:0] dataOut;

	instrMem _instrMem(reset, address, dataOut);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _instrMem);

		// reset
		#1 reset = 1;
		#1 reset = 0;

		// memory read
		#1 address = 0;
		#1 address = 1;
		#1 address = 2;
		#1 address = 3;
		#1 address = 4;
		#1 address = 5;
		#1 address = 6;
		#1 address = 7;
		#1 address = 8;
		#1 address = 255;

		#1 $finish;
	end

endmodule
