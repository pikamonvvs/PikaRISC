`ifndef __COMPARATOR_V__
`define __COMPARATOR_V__

module comparator(
	input [31:0] val1,
	input [31:0] val2,
	input is_cmp_op,
	output [3:0] nzcv
	);

	wire [32:0] diff;
	wire overflow, underflow;

	assign diff = (is_cmp_op) ? { val1[31], val1 } - { val2[31], val2 } : 32'd0;
	assign n = diff[31];
	assign z = (diff == 0) ? 1'b1 : 1'b0;
	assign c = diff[32];
	assign v = overflow | underflow;
	assign overflow  = (diff[32:31] == 2'b01) ? 1'b1 : 1'b0;
	assign underflow = (diff[32:31] == 2'b10) ? 1'b1 : 1'b0;
	assign nzcv = { n, z, c, v };

endmodule // comparator

`endif /*__COMPARATOR_V__*/