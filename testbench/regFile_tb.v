`timescale 1ms/1ms

`include "../sources/memory/regFile.v"

module regFile_tb();
	reg reset;
	reg [31:0] if_pc_in;
	wire [31:0] if_pc_out;
	reg [3:0] exe_rd_num;
	wire [31:0] exe_rd_data_out;
	reg [3:0] exe_rs_num;
	wire [31:0] exe_rs_data_out;
	reg [3:0] exe_rt_num;
	wire [31:0] exe_rt_data_out;
	wire [31:0] exe_cpsr_out;
	reg [3:0] wb_rd_num;
	reg wb_rd_write_en;
	reg [31:0] wb_rd_in;
	reg wb_pc_write_en;
	reg [31:0] wb_pc_in;
	reg wb_cpsr_write_en;
	reg [31:0] wb_cpsr_in;
	integer i = 0;

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

		.wb_pc_write_en(wb_pc_write_en),
		.wb_pc_in(wb_pc_in),

		.wb_cpsr_write_en(wb_cpsr_write_en),
		.wb_cpsr_in(wb_cpsr_in)
	);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _regFile);

		// initialize
		reset = 1;
		if_pc_in = 0;
		exe_rd_num = 0;
		exe_rs_num = 0;
		exe_rt_num = 0;
		wb_rd_num = 0;
		wb_rd_write_en = 0;
		wb_rd_in = 0;
		wb_pc_write_en = 0;
		wb_pc_in = 0;
		wb_cpsr_write_en = 0;
		wb_cpsr_in = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

		// wb pc write
		// if pc read
		wb_pc_write_en = 1;
		for (i = 0; i < 44; i = i + 1) begin
			#1 wb_pc_in <= i; // if_pc_out
		end

		// wb cpsr write
		// exe cpsr read
		wb_cpsr_write_en = 1;
		for (i = 0; i < 16; i = i + 1) begin
			#1 wb_cpsr_in <= i; // exe_cpsr_out
		end

		// exe rd rs rt write
		// exe rd rs rt read
		wb_rd_write_en = 1;
		for (i = 0; i < 16; i = i + 1) begin
			#1 wb_rd_num <= i;
			   wb_rd_in <= i;
			   exe_rd_num <= i; // exe_rd_data_out
			   exe_rs_num <= i; // exe_rs_data_out
			   exe_rt_num <= i; // exe_rt_data_out
		end

		#1 $finish;
	end

endmodule
