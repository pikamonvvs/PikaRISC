test.vcd:	test.vvp
	gtkwave test.vcd
test.vvp:	testbench.v
	iverilog -I sources/ -DFOR_TEST -o test.vvp testbench.v
#	iverilog -I sources/ -o test.vvp testbench.v
	vvp test.vvp

clean:
	rm -f *.vvp
	rm -f *.vcd
