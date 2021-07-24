`ifndef __WRITEBACK_V__
`define __WRITEBACK_V__

module writeback(
	input [3:0] rd_num_passthrough, // ld
	input [31:0] md_passthrough, // ld, str
	input [31:0] result, // alu
	input [31:0] cpsr_in,
	input [31:0] dmem_val_passthrough, // to writeback
	input taken,

	input is_alu_op_passthrough,
	input is_cmp_op_passthrough,
	input is_jmp_op_passthrough,
	input is_ld_op_passthrough,

	// to regFile
	output reg [3:0] reg_num, // TODO: data memory size
	output reg reg_write_en, // TODO: it is thought not needed
	output reg [31:0] reg_val,
	// pc
	output reg [31:0] pc_out,
	output reg pc_write_en, // TODO: it is thought not needed
	// cpsr
	output reg [31:0] cpsr_out,
	output reg cpsr_write_en // TODO: it is thought not needed
	);

	always @ (*) begin
		// alu
		if (is_alu_op_passthrough) begin
			// write result to num
			reg_num <= rd_num_passthrough;
			reg_val <= result;
			reg_write_en <= 1'b1;
			cpsr_write_en <= 1'b0; // TODO: preventing but necessity
			pc_write_en <= 1'b0; // TODO: preventing but necessity
		end
		// compare
		if (is_cmp_op_passthrough) begin
			// write nzcv to cpsr
			cpsr_out <= cpsr_in;
			cpsr_write_en <= 1'b1;
			pc_write_en <= 1'b0; // TODO: preventing but necessity
			reg_write_en <= 1'b0; // TODO: preventing but necessity
		end
		// branch
		if (is_jmp_op_passthrough && taken) begin
			// write md to pc
			pc_out <= md_passthrough;
			pc_write_en <= 1'b1;
			reg_write_en <= 1'b0; // TODO: preventing but necessity
			cpsr_write_en <= 1'b0; // TODO: preventing but necessity
		end
		// load
		if (is_ld_op_passthrough) begin
			// write result to num
			reg_num <= rd_num_passthrough;
			reg_val <= dmem_val_passthrough;
			reg_write_en <= 1'b1;
			cpsr_write_en <= 1'b0; // TODO: preventing but necessity
			pc_write_en <= 1'b0; // TODO: preventing but necessity
		end
	end

endmodule // writeback

`endif /* __WRITEBACK_V__ */