`timescale 1ms/1ms

`include "../sources/stages/writeback.v"
`include "../sources/memory/regFile.v"

module writeback_tb();
	reg reset;

	reg [3:0] rd_num_passthrough;
	reg [31:0] md_passthrough;
	reg [31:0] result;
	reg [31:0] cpsr_passthrough;
	reg [31:0] dmem_val_passthrough;
	reg is_alu_op_passthrough;
	reg is_cmp_op_passthrough;
	reg is_ld_op_passthrough;
	wire [3:0] rd_num;
	wire rd_write_en;
	wire [31:0] rd_val;
	wire cpsr_write_en;
	wire [31:0] cpsr_out;

	reg [31:0] if_pc_in;
	wire [31:0] if_pc_out;
	reg [3:0] exe_rd_num;
	wire [31:0] exe_rd_data_out;
	reg [3:0] exe_rs_num;
	wire [31:0] exe_rs_data_out;
	reg [3:0] exe_rt_num;
	wire [31:0] exe_rt_data_out;
	wire [31:0] exe_cpsr_out;
	wire [3:0] wb_rd_num;
	wire wb_rd_write_en;
	wire [31:0] wb_rd_in;
	wire wb_cpsr_write_en;
	wire [31:0] wb_cpsr_in;
`ifdef FOR_TEST
	wire [31:0] wb_rd_out;
	wire [31:0] wb_cpsr_out;
`endif

	integer i = 0;

	writeback _writeback(
		.rd_num_passthrough(rd_num_passthrough),
		.md_passthrough(md_passthrough),
		.result(result),
		.cpsr_passthrough(cpsr_passthrough),
		.dmem_val_passthrough(dmem_val_passthrough),
		.is_alu_op_passthrough(is_alu_op_passthrough),
		.is_cmp_op_passthrough(is_cmp_op_passthrough),
		.is_ld_op_passthrough(is_ld_op_passthrough),

		.rd_num(wb_rd_num),
		.rd_write_en(wb_rd_write_en),
		.rd_val(wb_rd_in),
		.cpsr_write_en(wb_cpsr_write_en),
		.cpsr_out(wb_cpsr_in)
	);

	regFile _regFile(
		.reset(reset),
		.if_pc_in(if_pc_in),
		.if_pc_out(if_pc_out),
		.exe_rd_num(exe_rd_num),
		.exe_rd_data_out(exe_rd_data_out),
		.exe_rs_num(exe_rs_num),
		.exe_rs_data_out(exe_rs_data_out),
		.exe_rt_num(exe_rt_num),
		.exe_rt_data_out(exe_rt_data_out),
		.exe_cpsr_out(exe_cpsr_out),

		.wb_rd_num(wb_rd_num),
		.wb_rd_write_en(wb_rd_write_en),
		.wb_rd_in(wb_rd_in),
		.wb_cpsr_write_en(wb_cpsr_write_en),
		.wb_cpsr_in(wb_cpsr_in)
`ifdef FOR_TEST
		,
		.wb_rd_out(wb_rd_out),
		.wb_cpsr_out(wb_cpsr_out)
`endif
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _writeback);
		$dumpvars(-1, _regFile);

		// initialize
		reset = 1;

		rd_num_passthrough = 0;
		md_passthrough = 0;
		result = 0;
		cpsr_passthrough = 0;
		dmem_val_passthrough = 0;
		is_alu_op_passthrough = 0;
		is_cmp_op_passthrough = 0;
		is_jmp_op_passthrough = 0;
		is_ld_op_passthrough = 0;

		if_pc_in = 0;
		exe_rd_num = 0;
		exe_rs_num = 0;
		exe_rt_num = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

		// alu (result -> rd)
		is_alu_op_passthrough <= 1;
		is_cmp_op_passthrough <= 0;
		is_jmp_op_passthrough <= 0;
		is_ld_op_passthrough <= 0;
		for (i = 0; i < 16; i = i + 1) begin
			#1 rd_num_passthrough <= i;
			   result <= i; // wb_rd_out
		end

		// cmp (nzcv -> cpsr)
		#1 is_alu_op_passthrough <= 0;
		is_cmp_op_passthrough <= 1;
		is_jmp_op_passthrough <= 0;
		is_ld_op_passthrough <= 0;
		for (i = 0; i < 16; i = i + 1) begin
			#1 cpsr_passthrough <= i; // wb_cpsr_out
		end

		// ld (dmem_val -> rd)
		#1 is_alu_op_passthrough <= 0;
		is_cmp_op_passthrough <= 0;
		is_jmp_op_passthrough <= 0;
		is_ld_op_passthrough <= 1;
		for (i = 0; i < 16; i = i + 1) begin
			#1 rd_num_passthrough <= i;
			   dmem_val_passthrough <= i; // wb_rd_out
		end

		#1 $finish;
	end

endmodule