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
        $display("============================");
        // TEST BENCH IS FOR WAITTIME = 3
        pin = 0;
        #300
        pin = 1;
        i=0;
        // There should be 5 cycles of 20 time units before the 
        // input is counted as actually being high (not just a glitch)
        for (i=0; i<5; i=i+1) begin
            #20
            if (conditioned == 1)
                $display("DUT inputconditioner failed! Conditioned went high too soon");
        end
        // After the 5 cycles, conditioned should then be set high
        #20
        if (conditioned == 0) begin
            $display("DUT inputconditioner failed! Conditioned does not go high soon enough");
        end else if (rising == 0) begin
            $display("DUT inputconditioner positiveedge failed! Not high on posedge of conditioned");
        end else begin
            $display("DUT inputconditioner passed!");
        end
        #300
        // Set input back to 0
        pin = 0;
        #300
        // Glitch; should not set conditioned
        pin = 1;
        #70
        pin = 0;
        #300
        pin = 1;
        #200 // 200 is longest for 10 waittime, 70 is longest time for glitch for 3 waittime
        pin = 0;
        #500
        // These following glitches should not end up setting conditioned to high
        pin = 1;
        #20
        pin = 0;
        #20
        pin = 1;
        #20
        pin = 0;
        #20
        // should set conditioned to high
        pin = 1;
        #300
        pin = 0;
        #300 $finish;
    end
endmodule
