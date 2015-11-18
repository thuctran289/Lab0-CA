// tests the decoder
module testdecoder1to32();
	
	wire [31:0] out;
	reg 		enable;
	reg [4:0] 	address;

	decoder1to32 DUT
	(
		.out(out),
		.enable(enable),
		.address(address)
	);

	reg dutpassed;
	integer i;

    initial begin
	    $dumpfile("decoder1to32.t.vcd");
	    $dumpvars(0, testdecoder1to32);
	    
	    $display("Decoder 5:32 w/ E test bench");
        $display("----------------------------");

	    dutpassed = 1;

	    // Test Case 1:
	    // 	   Check if enable off sets no output
	    enable = 0; #5;
	    for(i=0; i<5'b11111; i=i+1) begin
	    	address = i; #10;
	    	if (out != 0) begin
	    		$display("Test Case 1 Failed - Enable is broken");
	    		$display("out reads %d for address $d and enable %b", out, address, enable);
	    	end
	    end

	    // Test Case 2:
	    // 	   Check if enable on sets some output
	    enable = 1; #5;
	    for(i=0; i<5'b11111; i=i+1) begin
	    	address = i; #10;
	    	if (out == 0) begin
	    		$display("Test Case 2 Failed - Enable is broken");
	    		$display("out reads %d for address $d and enable %b", out, address, enable);
	    	end
	    end

		// Test Case 3:
	    // 	   Check if correct address is set when enable is on
	    enable = 1; #5;
	    for(i=0; i<5'b11111; i=i+1) begin
	    	address = i; #10;
	    	if (out[i] == 0) begin
	    		$display("Test Case 3 Failed - Out is not set correctly when enable is on");
	    		$display("out reads %d for address $d and enable %b", out, address, enable);
	    	end
	    end	

	    if(dutpassed == 0) begin
        	$display("Decoder is broken!!");
    	end else begin
        	$display("Decoder works!!");
    	end    

	    $finish;
	end

endmodule