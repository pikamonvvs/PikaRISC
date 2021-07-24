top.vcd:	top.vvp
	gtkwave top.vcd
top.vvp:	top_tb.v
	iverilog -I sources/ -o top.vvp top_tb.v
	vvp top.vvp

clean:
	rm -f *.vvp
	rm -f *.vcd
