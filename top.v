`ifndef __TOP_V__
`define __TOP_V__

`include "sources/alu.v"
`include "sources/comparator.v"
`include "sources/condChecker.v"
`include "sources/defines.v"
`include "sources/signExtend.v"
`include "sources/memory/dataMem.v"
`include "sources/memory/instrMem.v"
`include "sources/memory/regFile.v"
`include "sources/stages/fetch.v"
`include "sources/stages/decode.v"
`include "sources/stages/execute.v"
`include "sources/stages/memory.v"
`include "sources/stages/writeback.v"

module PikaRISC(
	input clk,
	input reset
	);

	// TODO:
	
endmodule // PikaRISC

`endif /*__TOP_V__*/