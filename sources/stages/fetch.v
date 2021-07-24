`ifndef __FETCH_V__
`define __FETCH_V__

module fetch(
	input clk,
	input reset,
	output [31:0] instruction,

	// to instrMem
	output [21:0] imem_addr,
	input [31:0] imem_data,

	// to regFile
	input [31:0] pc_in,
	output reg [31:0] pc_out, // FIXME:

	//to execute
	input taken
	);

	always @ (posedge clk or negedge reset) begin
		if (!reset)
		begin
			pc_out <= 0;
		end
		else
		begin
			if (!taken)
				pc_out <= pc_in + 4;
		end
	end

	assign imem_addr = pc_in[21:0];
	assign instruction = {{imem_data[7:0], imem_data[15:8], imem_data[23:16], imem_data[31:24]}}; // to big endian

endmodule // fetch

`endif /* __FETCH_V__ */