iverilog -o testprogramcounter.t.vcd testbenches/programcounter.t.v programcounter.v
vvp testprogramcounter.t.vcd

iverilog -o testconcatenate.t.vcd testbenches/concatenate.t.v concatenate.v 
vvp testconcatenate.t.vcd


iverilog -o testsignextend.t.vcd testbenches/signextend.t.v signextend.v 
vvp testsignextend.t.vcd


iverilog -o testmux.t.vcd testbenches/mux.t.v mux.v 
vvp testmux.t.vcd

iverilog -o testFullAdder30.t.vcd testbenches/FullAdder30.t.v FullAdder30.v 
vvp testFullAdder30.t.vcd

iverilog -o instructionfetch.t.vcd testbenches/instructionfetch.t.v instructionfetch.v mux.v programcounter.v signextend.v FullAdder30.v concatenate.v memory.v
vvp instructionfetch.t.vcd 