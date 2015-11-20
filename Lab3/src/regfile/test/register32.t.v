// ------------------------- //
// Test bench for register32 //
// ------------------------- //
module testregister32();
	wire [31:0] q;
	reg	[31:0] d;
	reg wrenable;
	reg	clk;

	register32 dut
	(
		.q(q),
		.d(d),
		.wrenable(wrenable),
		.clk(clk)
	);

	reg dutpassed;
	integer i;

	initial begin
		$dumpfile("register32.t.vcd");
	    $dumpvars(0, testregister32);
	    
	    $display("32 bit Register test bench");
        $display("--------------------------");

	    dutpassed = 1;

	    // Test Case 1:
	    //    If wrenable is on, check if q is d
	    wrenable = 1;
	    for(i=0; i<32; i=i+1) begin
	    	d = i;
	    	#5 clk=1; #5 clk=0;
	    	if(q != i) begin
            	dutpassed = 0;
            	$display("Test Case 1 Failed - q != d when wrenable is high");
            	$display("q reads %d for d of %d", q, d);
       		end
	    end

	    // Test Case 2:
	    //    If wrenable if off, q should always hold its state
	    d = 0;
	    #5 clk=1; #5 clk=0;
	    wrenable = 0;
	    for(i=0; i<32; i=i+1) begin
	    	d = i;
	    	#5 clk=1; #5 clk=0;
	    	if(q != 0) begin
            	dutpassed = 0;
            	$display("Test Case 2 Failed - q != q_previous when wrenable is low");
            	$display("q reads %d for d of %d and wrenable %d", q, d, wrenable);
       		end
	    end

	    // Test Case 3:
	    //    Make sure every wire works
	    d = 0;
	    #5 clk=1; #5 clk=0;
	    wrenable = 1;
	    for(i=0; i<32; i=i+1) begin
	    	d = 2**i;
	    	#5 clk=1; #5 clk=0;
	    	if(q != 2**i) begin
            	dutpassed = 0;
            	$display("Test Case 3 Failed - q != d when wrenable is high; a bit is broken");
            	$display("q[%d] reads %d for d[%d] and wrenable %d", i, q[i], i, d[i], wrenable);
       		end
	    end

	    if(dutpassed == 0) begin
        	$display("32 bit Register is broken!!");
    	end else begin
        	$display("32 bit Register works!!");
    	end  

    	$finish; 
    end

endmodule
