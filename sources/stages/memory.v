`ifndef __MEMORY_V__
`define __MEMORY_V__

// ld : mem(md) -> wb(rd_num_passthrough)
// str: exe(rd_val_passthrough) -> mem(md32)

module memory(
	input [31:0] md_passthrough, // ld, str
	input [31:0] result, // str
	input [31:0] rd_val_passthrough, // str
	output reg [31:0] dmem_val_passthrough, // to writeback // FIXME:

	input is_ld_op_passthrough,
	input is_str_op_passthrough,

	// to dataMem
	output reg [31:0] dmem_addr, // TODO: data memory size // FIXME:
	output reg dmem_write_en, // FIXME:
	output reg [31:0] dmem_val_out, // FIXME:
	input [31:0] dmem_val_in
	);

	always @ (*) begin
		if (is_ld_op_passthrough) begin
			dmem_addr <= md_passthrough;
			dmem_write_en <= 1'b0;
			dmem_val_passthrough <= dmem_val_in; // TODO: need to test if it is correct
		end
		if (is_str_op_passthrough) begin
			dmem_addr <= md_passthrough;
			dmem_val_out <= rd_val_passthrough;
			dmem_write_en <= 1'b1;
		end
	end

endmodule // memory

`endif /* __MEMORY_V__ */