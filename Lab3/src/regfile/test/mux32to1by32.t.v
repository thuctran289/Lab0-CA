module testmux32to1by32()
	wire [31:0]    out,
	reg [4:0]      address,
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

	integer i;

	initial begin
		$dumpfile("mux32to1by32.t.vcd");
	    $dumpvars(0, testmux32to1by32);
	    
	    $display("32:1 by 32 Mux test bench");
        $display("-------------------------");

	    dutpassed = 1;

	    // Test Case 1:
	    //     Check if out is the correct address for all addresses

	    address 
		
	end

endmodule
