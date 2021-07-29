`ifndef __WRITEBACK_V__
`define __WRITEBACK_V__

module writeback(
	input [3:0] rd_num_passthrough, // ld
	input [31:0] mem_passthrough, // ld, str
	input [31:0] result, // alu
	input [31:0] cpsr_passthrough,
	input [31:0] dmem_val_passthrough, // to writeback

	input is_alu_op_passthrough,
	input is_cmp_op_passthrough,
	input is_ld_op_passthrough,

	// to regFile
	// rd
	output reg [3:0] rd_num, // TODO: data memory size
	output reg rd_write_en, // TODO: it is thought not needed
	output reg [31:0] rd_val,
	// cpsr
	output reg cpsr_write_en, // TODO: it is thought not needed
	output reg [31:0] cpsr_out
	);

	always @ (*) begin
		// alu
		if (is_alu_op_passthrough) begin
			// write result to num
			rd_num <= rd_num_passthrough;
			rd_val <= result;
			rd_write_en <= 1'b1;
			cpsr_write_en <= 1'b0; // TODO: preventing but necessity
		end
		// compare
		if (is_cmp_op_passthrough) begin
			// write nzcv to cpsr
			cpsr_out <= cpsr_passthrough;
			cpsr_write_en <= 1'b1;
			rd_write_en <= 1'b0; // TODO: preventing but necessity
		end
		// load
		if (is_ld_op_passthrough) begin
			// write result to num
			rd_num <= rd_num_passthrough;
			rd_val <= dmem_val_passthrough;
			rd_write_en <= 1'b1;
			cpsr_write_en <= 1'b0; // TODO: preventing but necessity
		end
	end

endmodule // writeback

`endif /* __WRITEBACK_V__ */