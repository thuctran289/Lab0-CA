// --------------------------- //
// Test bench for mux32to1by32 //
// --------------------------- //

module testmux32to1by32();
	wire [31:0]    out;
	reg [4:0]      address;
	reg [31:0]     input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31;

	mux32to1by32 dut
	(
		.out(out),
		.address(address),
		.input0(input0),
		.input1(input1),
		.input2(input2),
		.input3(input3),
		.input4(input4),
		.input5(input5),
		.input6(input6),
		.input7(input7),
		.input8(input8),
		.input9(input9),
		.input10(input10),
		.input11(input11),
		.input12(input12),
		.input13(input13),
		.input14(input14),
		.input15(input15),
		.input16(input16),
		.input17(input17),
		.input18(input18),
		.input19(input19),
		.input20(input20),
		.input21(input21),
		.input22(input22),
		.input23(input23),
		.input24(input24),
		.input25(input25),
		.input26(input26),
		.input27(input27),
		.input28(input28),
		.input29(input29),
		.input30(input30),
		.input31(input31)
	);

	reg dutpassed;
	integer i;

	initial begin
		$dumpfile("mux32to1by32.t.vcd");
	    $dumpvars(0, testmux32to1by32);
	    
	    $display("32:1 by 32 Mux test bench");
        $display("-------------------------");

	    dutpassed = 1;

	    // Test Case 1:
	    //     Check if out is the correct address for all addresses
	  	input0 = 32'd0;
		input1 = 32'd1;
		input2 = 32'd2;
		input3 = 32'd3;
		input4 = 32'd4;
		input5 = 32'd5;
		input6 = 32'd6;
		input7 = 32'd7;
		input8 = 32'd8;
		input9 = 32'd9;
		input10 = 32'd10;
		input11 = 32'd11;
		input12 = 32'd12;
		input13 = 32'd13;
		input14 = 32'd14;
		input15 = 32'd15;
		input16 = 32'd16;
		input17 = 32'd17;
		input18 = 32'd18;
		input19 = 32'd19;
		input20 = 32'd20;
		input21 = 32'd21;
		input22 = 32'd22;
		input23 = 32'd23;
		input24 = 32'd24;
		input25 = 32'd25;
		input26 = 32'd26;
		input27 = 32'd27;
		input28 = 32'd28;
		input29 = 32'd29;
		input30 = 32'd30;
		input31 = 32'd31;

	    for(i=0; i<32; i=i+1) begin
	    	address = i; #10;
	    	if (out != i) begin
	    		$display("Test Case 1 Failed - Out not reading correct address");
	    		$display("out reads %d for address %d,  for input %d", out, address, i);
	    		dutpassed = 0;
	    	end

	    end

	    // Test Case 2:
	    // 	  Check if output reads values other than if the value is the address number

	    input0 = 32'd35;
	    address = 0; #10
	    if (out != 32'd35) begin
	    	$display("Test Case 2 Failed - Out not reading correct value");
	    	$display("out reads %d for address %d,  for input %d", out, address, input0);
	    	dutpassed = 0;
	    end
		
		if(dutpassed == 0) begin
        	$display("Mux32to1by32 is broken!!");
    	end else begin
        	$display("Mux32to1by32 works!!");
    	end  

    	$finish;  
	end

endmodule
