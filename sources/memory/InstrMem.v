`ifndef __INSTRMEM_V__
`define __INSTRMEM_V__

`include "../defines.v"

module instrMem(
	input reset,
	input [31:0] addr,
	output [31:0] data_out
`ifdef FOR_TEST
	,
	input [31:0] test_addr,
	input [31:0] test_data_in,
	output [31:0] test_data_out
`endif
	);

	reg [31:0] memory[0:`IMEM_SIZE-1];
	integer i;

	initial
	begin
		for (i = 0; i < `IMEM_SIZE; i = i + 1)
			memory[i] <= 0;
	end

`ifdef FOR_TEST
	always @ (*) begin
		memory[test_addr[`IMEM_BITS-1:0]] <= test_data_in;
	end
`endif

	assign data_out = memory[addr[`IMEM_BITS-1:0]];

`ifdef FOR_TEST
	assign test_data_out = memory[test_addr];
`endif

endmodule // instrMem

`endif /*__INSTRMEM_V__*/