`timescale 1ms/1ms

`include "../sources/memory/instrMem.v"

module instrMem_tb();
	reg reset;

	reg [31:0] addr;
	wire [31:0] data_out;
`ifdef FOR_TEST
	reg [31:0] test_imem_addr;
	reg [31:0] test_imem_data_in;
	wire [31:0] test_imem_data_out;
`endif

	integer i = 0;

	instrMem _instrMem(
		.reset(reset),
		.addr(addr),
		.data_out(data_out)
`ifdef FOR_TEST
		,
		.test_addr(test_imem_addr),
		.test_data_in(test_imem_data_in),
		.test_data_out(test_imem_data_out)
`endif
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _instrMem);

		// initialize
		reset = 1;
		addr = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

		// memory read
		for (i = 0; i < 256; i = i + 1) begin
			#1 addr <= i;
		end

		#1 $finish;
	end

endmodule
