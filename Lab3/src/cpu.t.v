module testcpu();
	reg clk;

	cpu dut(.clk(clk));

	initial clk=0;
    always #10 clk=!clk;

	initial begin
		$dumpfile("cpu.t.vcd");
	    $dumpvars(0, testcpu);
	    
	    $display("CPU test bench");
        $display("--------------------------");
		#400;
		$finish;
	end
endmodule