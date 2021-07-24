`ifndef __REGFILE_V__
`define __REGFILE_V__

module regFile(
	input reset,

	// fetch - pc(rw)
	input [31:0] if_pc_in,
	output [31:0] if_pc_out,

	// execute - rd(r)
	input [3:0] exe_rd_num,
	output [31:0] exe_rd_data_out,

	// execute - rs(r)
	input [3:0] exe_rs_num,
	output [31:0] exe_rs_data_out,

	// execute - rt(r)
	input [3:0] exe_rt_num,
	output [31:0] exe_rt_data_out,

	// execute - cpsr(r)
	output [31:0] exe_cpsr_out,

	// writeback - rd(w)
	input [3:0] wb_rd_num,
	input wb_rd_write_en,
	input [31:0] wb_rd_in,

	// writeback - pc(w)
	input wb_pc_write_en,
	input [31:0] wb_pc_in,

	// writeback - cpsr(w)
	input wb_cpsr_write_en,
	input [31:0] wb_cpsr_in
	);

	// registers
	reg [31:0] regs[0:15];
	reg pc, cpsr;

	integer i;

	// reset
	always @ (*) begin
		if (!reset) begin
			for (i = 0; i < 16; i = i + 1)
				regs[i] <= 0;
			pc <= 0;
			cpsr <= 0;
		end
	end

	// fetch - pc(rw)
	always @ (*) begin
		pc <= if_pc_in; // TODO: is it right?
	end
	assign if_pc_out = pc;

	// execute - rd(r), rs(r), rt(r), cpsr(r)
	assign exe_rd_data_out = regs[exe_rd_num];
	assign exe_rs_data_out = regs[exe_rs_num];
	assign exe_rt_data_out = regs[exe_rt_num];
	assign exe_cpsr_out = cpsr;

	// writeback - rd(w), pc(w), cpsr(w)
	always @ (*) begin
		if (wb_rd_write_en)
			regs[wb_rd_num] <= wb_rd_in;
		if (wb_pc_write_en)
			pc <= wb_pc_in;
		if (wb_cpsr_write_en)
			cpsr <= wb_cpsr_in;
	end

endmodule // regFile

`endif /*__REGFILE_V__*/