`ifndef __COMPARATOR_V__
`define __COMPARATOR_V__

module comparator(
	input [31:0] val1,
	input [31:0] val2,
	input is_cmp_op,
	output [3:0] nzcv
	);

	reg [31:0] diff;
	reg n, z, c, v; // TODO: solutions to get

	always @ (*) begin
		if (is_cmp_op) begin
			diff <= val1 - val2; // TODO
		end
	end

	assign nzcv = { n, z, c, v };

endmodule // comparator

`endif /*__COMPARATOR_V__*/