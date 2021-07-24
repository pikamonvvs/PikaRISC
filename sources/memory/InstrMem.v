`ifndef __INSTRMEM_V__
`define __INSTRMEM_V__

`include "defines.v"

module instrMem(
	input reset,
	input [`IMEM_BITS-1:0] addr, // 2MB
	output [31:0] data_out
	);

	reg [31:0] memory[0:`IMEM_SIZE-1];
	integer i;

	always @ (*) begin
		if (!reset) begin
			for (i = 0; i < `IMEM_SIZE; i = i + 1)
				memory[i] <= 0;
//				memory[i] <= `IMEM_SIZE - 1 - i; // for test
		end
	end

	assign data_out = memory[addr];

endmodule // instrMem

`endif /*__INSTRMEM_V__*/