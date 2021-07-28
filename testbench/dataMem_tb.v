`timescale 1ms/1ms

`include "../sources/memory/dataMem.v"

module dataMem_tb();
	reg reset;

	reg [31:0] addr;
	reg [31:0] data_in;
	reg write_en;
	wire [31:0] data_out;

	integer i = 0;

	dataMem _dataMem(
		.reset(reset),
		.addr(addr),
		.data_in(data_in),
		.write_en(write_en),
		.data_out(data_out)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _dataMem);

		// initialize
		reset = 1;
		addr = 0;
		data_in = 0;
		write_en = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

		// memory write
		write_en = 1;
		for (i = 0; i < 256; i = i + 1) begin
			#1 addr <= i;
			data_in <= i;
		end

		// memory read
		#1 write_en = 0;
		for (i = 0; i < 256; i = i + 1) begin
			#1 addr <= i;
		end

		#1 $finish;
	end

endmodule