`ifndef __REGFILE_V__
`define __REGFILE_V__

module regFile(
	input reset,
	input [3:0] reg_num,
	input reg_write_en,
	input [31:0] reg_data_in,
	output [31:0] reg_data_out,

	// pc
	input [31:0] pc_in,
	input pc_write_en,
	output [31:0] pc_out,

	// cpsr
	input [31:0] cpsr_in,
	input cpsr_write_en,
	output [31:0] cpsr_out
	);

	// registers
	reg [31:0] regs[0:15];
	reg pc;
	reg cpsr;

	integer i;

	always @ (*) begin
		if (!reset) begin
			for (i = 0; i < 16; i = i + 1)
				regs[i] <= 0;
		end
		else
		begin
			if (reg_write_en)
				regs[reg_num] <= reg_data_in;
			if (pc_write_en)
				pc <= pc_in;
			if (cpsr_write_en)
				cpsr <= pc_in;
		end
	end

	assign reg_data_out = regs[reg_num];
	assign pc_out = pc;
	assign cpsr_out = cpsr;

endmodule // regFile

`endif /*__REGFILE_V__*/