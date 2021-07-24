`ifndef __DATAMEM_V__
`define __DATAMEM_V__

`include "defines.v"

module dataMem(
	input reset,
	input [31:0] addr,
	input write_en,
	input [31:0] data_in,
	output [31:0] data_out
	);

	reg [31:0] memory[0:`DMEM_SIZE-1];
	integer i;

	always @ (*) begin
		if (!reset) begin
			for (i = 0; i < `DMEM_SIZE; i = i + 1)
				memory[i] <= 0;
		end
		else begin
			if (write_en) begin
				memory[addr[`DMEM_BITS-1:0]] <= { data_in[7:0], data_in[15:8], data_in[23:16], data_in[31:24] };
			end
		end
	end

	assign data_out = { memory[addr][7:0], memory[addr][15:8], memory[addr][23:16], memory[addr][31:24] };

endmodule // dataMem

`endif /*__DATAMEM_V__*/