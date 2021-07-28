`timescale 1ms/1ms

`include "../sources/stages/fetch.v"
`include "../sources/memory/regFile.v"
`include "../sources/memory/instrMem.v"

module fetch_tb();
	reg clk;
	reg reset;

	wire [31:0] instruction;
	wire [31:0] imem_addr;
	wire [31:0] imem_data;
	wire [31:0] pc_in;
	wire [31:0] pc_out;
	reg taken;
	reg [31:0] pc_rel;

	wire [31:0] if_pc_in;
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
	reg wb_cpsr_write_en;
	reg [31:0] wb_cpsr_in;
`ifdef FOR_TEST
	wire [31:0] wb_rd_out;
	wire [31:0] wb_cpsr_out;
`endif

`ifdef FOR_TEST
	reg [31:0] buffer[0:255];
	wire [31:0] test_imem_addr;
	wire [31:0] test_imem_data_in;
	wire [31:0] test_imem_data_out;
	reg [31:0] test_imem_addr_reg;
	reg [31:0] test_imem_data_in_reg;
`endif

	integer i = 0;

	fetch _fetch(
		.clk(clk),
		.reset(reset),

		.instruction(instruction),

		.imem_addr(imem_addr),
		.imem_data(imem_data),

		.pc_in(if_pc_out),
		.pc_out(if_pc_in),

		.taken(taken),
		.pc_rel(pc_rel)
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

	instrMem _instrMem(
		.reset(reset),
		.addr(imem_addr),
		.data_out(imem_data)
`ifdef FOR_TEST
		,
		.test_addr(test_imem_addr),
		.test_data_in(test_imem_data_in),
		.test_data_out(test_imem_data_out)
`endif
	);

`ifdef FOR_TEST
	assign test_imem_addr = test_imem_addr_reg;
	assign test_imem_data_in = test_imem_data_in_reg;
`endif

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(-1, _fetch);
		$dumpvars(-1, _regFile);
		$dumpvars(-1, _instrMem);

		// initialize
		reset = 1;
		clk = 0;

		taken = 0;
		pc_rel = 0;

		exe_rd_num = 0;
		exe_rs_num = 0;
		exe_rt_num = 0;
		wb_rd_num = 0;
		wb_rd_write_en = 0;
		wb_rd_in = 0;
		wb_cpsr_write_en = 0;
		wb_cpsr_in = 0;

		// reset
		#1 reset = 0;
		#1 reset = 1;

`ifdef FOR_TEST
		// code injection
		$readmemh("test.hex", buffer);
		for (i = 0; i < 44; i = i + 1) begin
			#1 test_imem_addr_reg = i;
			test_imem_data_in_reg = buffer[i];
		end
`endif

		// start clock trigger
		repeat (88) begin
			#1 clk = ~clk;
		end

		// branch taken forward
		#2 taken <= 1'b1;
		pc_rel <= 32'h1000;
		#1 clk = ~clk;
		#1 clk = ~clk;
		taken <= 1'b0;

		// branch taken backward
		#2 taken <= 1'b1;
		pc_rel <= 32'hfffff000;
		#1 clk = ~clk;
		#1 clk = ~clk;
		taken <= 1'b0;

		#1 $finish;
	end

endmodule