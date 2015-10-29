//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
    $dumpfile("inputconditioner.t.vcd");
    $dumpvars(0, testConditioner);
    $display("hello world");
    pin = 0;
    #1000 //70 is longest time for glitch
    pin = 1;
    #200
    pin = 0;
    #200
    pin = 1;
    #230 // 220 is longest for 10 waittime
    pin = 0;
    #20 $finish;
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)
end

    
endmodule
