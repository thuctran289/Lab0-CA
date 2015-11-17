iverilog -o testprogramcounter.t.vcd programcounter.t.v programcounter.v
vvp testprogramcounter.t.vcd

iverilog -o testconcatenate.t.vcd concatenate.t.v concatenate.v
vvp testconcatenate.t.vcd


iverilog -o testsignextend.t.vcd signextend.t.v signextend.v
vvp testsignextend.t.vcd


iverilog -o testMUX.t.vcd mux.t.v mux.v
vvp testMUX.t.vcd