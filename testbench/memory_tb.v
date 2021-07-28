`timescale 1ms/1ms

`include "../sources/stages/memory.v"
`include "../sources/memory/dataMem.v"

module memory_tb();
	reg reset;

	reg is_ld_op_passthrough;
	reg is_str_op_passthrough;
	reg [31:0] md_passthrough;
	reg [31:0] rd_val_passthrough;

	// to writeback
	wire [31:0] dmem_val_passthrough;

	// to dataMem
	wire [31:0] dmem_addr;
	wire dmem_write_en;
	wire [31:0] dmem_val_out;
	wire [31:0] dmem_val_in;

	integer i = 0;

	memory _memory(
		.is_ld_op_passthrough(is_ld_op_passthrough),
		.is_str_op_passthrough(is_str_op_passthrough),
		.md_passthrough(md_passthrough),
		.rd_val_passthrough(rd_val_passthrough),

		.dmem_val_passthrough(dmem_val_passthrough),

		.dmem_addr(dmem_addr),
		.dmem_write_en(dmem_write_en),
		.dmem_val_out(dmem_val_out),
		.dmem_val_in(dmem_val_in)
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
		$dumpvars(-1, _memory);
		$dumpvars(-1, _dataMem);

		// initialize
		reset = 1;
		md_passthrough = 0;
		rd_val_passthrough = 0;
		is_ld_op_passthrough = 0;
		is_str_op_passthrough = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

		// store
		is_ld_op_passthrough <= 0;
		is_str_op_passthrough <= 1;
		for (i = 0; i < 256; i = i + 1) begin
			#1 md_passthrough <= i;
			   rd_val_passthrough <= i; // dmem_val_in
		end

		// load
		#1 is_ld_op_passthrough <= 1;
		   is_str_op_passthrough <= 0;
		for (i = 0; i < 256; i = i + 1) begin
			#1 md_passthrough <= i; // dmem_val_passthrough
		end

		#1 $finish;
	end

endmodule