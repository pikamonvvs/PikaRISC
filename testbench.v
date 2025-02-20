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

`ifdef FOR_TEST
	reg [31:0] buffer[0:255];
	wire [31:0] test_imem_addr;
	wire [31:0] test_imem_data_in;
	wire [31:0] test_imem_data_out;
	reg [31:0] test_imem_addr_reg;
	reg [31:0] test_imem_data_in_reg;
	integer i = 0;
`endif


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
`ifdef FOR_TEST
		,
		.test_addr(test_imem_addr),
		.test_data_in(test_imem_data_in),
		.test_data_out(test_imem_data_out)
`endif
	);

	dataMem _dataMem(
		.reset(reset),
		.addr(dmem_addr),
		.write_en(dmem_write_en),
		.data_in(dmem_val_out),
		.data_out(dmem_val_in)
	);

`ifdef FOR_TEST
	assign test_imem_addr = test_imem_addr_reg;
	assign test_imem_data_in = test_imem_data_in_reg;
`endif

	initial begin
		// for simulation
		$dumpfile("test.vcd");
		$dumpvars(-1, _PikaRISC);
		$dumpvars(-1, _instrMem);
		$dumpvars(-1, _dataMem);

		// initialize
		clk = 1;
		reset = 1;

		// reset
		#1 reset = 0;
		#1 reset = 1;

`ifdef FOR_TEST
		// test probe
//		$dumpvars(-1, test_imem_addr);
//		$dumpvars(-1, test_imem_data_in);
//		$dumpvars(-1, test_imem_data_out);

		// code injection
		$readmemh("test.hex", buffer);
		for (i = 0; i < 44; i = i + 1) begin
			#1 test_imem_addr_reg = i;
			test_imem_data_in_reg = buffer[i];
		end
`endif

		// start clock trigger
		repeat (44) begin
			#1 clk = ~clk;
			#1 clk = ~clk;
		end

		#1 $finish;
	end

endmodule