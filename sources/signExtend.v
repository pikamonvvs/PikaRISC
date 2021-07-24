`ifndef __SIGNEXTEND_V__
`define __SIGNEXTEND_V__

module signExtendImm(
	input [17:0] in,
	output [31:0] out
	);

	assign out = (in[17] == 1) ? {14'b11111111111111, in} : {14'b00000000000000, in};

endmodule // end signExtendImm

module signExtendMd(in, out);
	input [21:0] in;
	output [31:0] out;

	assign out = (in[21] == 1) ? {10'b1111111111, in} : {10'b0000000000, in};

endmodule // signExtendMd

`endif /*__SIGNEXTEND_V__*/