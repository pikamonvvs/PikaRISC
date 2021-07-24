`timescale 1ms/1ms

`include "top.v"

`include "sources/memory/dataMem.v"
`include "sources/memory/instrMem.v"

module testbench();
	reg clk;
	reg reset;

	wire [31:0] imem_addr;
	wire [31:0] imem_data;
	wire [31:0] dmem_addr;
	wire dmem_write_en;
	wire [31:0] dmem_val_out;
	wire [31:0] dmem_val_in;

	PikaRISC _PikaRISC(
		.clk(clk),
		.reset(reset),

		.imem_addr(imem_addr),
		.imem_data(imem_data),
		.dmem_addr(dmem_addr),
		.dmem_write_en(dmem_write_en),
		.dmem_val_out(dmem_val_out),
		.dmem_val_in(dmem_val_in)
	);

	instrMem _instrMem(
		.reset(reset),
		.addr(imem_addr),
		.data_out(imem_data)
	);

	dataMem _dataMem(
		.reset(reset),
		.addr(dmem_addr),
		.write_en(dmem_write_en),
		.data_in(dmem_val_out),
		.data_out(dmem_val_in)
	);

	initial begin
		$dumpfile("test.vcd");
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