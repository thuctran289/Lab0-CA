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
    integer i;
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
        $dumpfile("inputconditioner.t.vcd");
        $dumpvars(0, testConditioner);
        $display("Input conditioner test bench");
        // TEST BENCH IS FOR WAITTIME = 3
        pin = 0;
        #300
        pin = 1;
        i=0;
        for (i=0; i<5; i=i+1) begin
            #20
            if (conditioned == 1)
                $display("DUT inputconditioner failed! Conditioned went high too soon");
        end
        #20
        if (conditioned == 0) begin
            $display("DUT inputconditioner failed! Conditioned does not go high soon enough");
        end else if (rising == 0) begin
            $display("DUT inputconditioner positiveedge failed! Not high on posedge of conditioned");
        end else begin
            $display("DUT inputconditioner passed!");
        end
        #300
        pin = 0;
        #300
        pin = 1;
        #250
        pin = 0;
        #500
        pin = 1;
        #200 // 220 is longest for 10 waittime, 70 is longest time for glitch for 3 waittime
        pin = 0;
        #500
        pin = 1;
        #20
        pin = 0;
        #20
        pin = 1;
        #300
        pin = 0;
        #20 $finish;
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)
    end
endmodule
