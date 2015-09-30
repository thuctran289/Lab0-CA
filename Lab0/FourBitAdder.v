//Delays 
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50

module FourAdder4bit
	(
		output [3:0] sum;
		output carryout;
		output overflow;
		input [3:0] a;
		input [3:0] b;
	);

	// four 1-bit adders chained together to make a 4-bit adder
	wire c0, c1,c2; // each adder has its own cut which becomes cin of next
	structuralFullAdder adder0 (sum[0], c0, a[0], b[0], 0);
	structuralFullAdder adder1 (sum[1], c1, a[1], b[1], c0);
	structuralFullAdder adder2 (sum[2], c2, a[2], b[2], c1);
	structuralFullAdder adder3 (sum[3], carryout, a[3], b[3], c2);

	// XOR the carryin and carryout of the 4th adder to check for overflow
	`XOR(overflow, c2, carryout);
endmodule

module test4BitAdd;
	wire [3:0]out;
	wire cout;
	reg [3:0] a;
	reg [3:0] b;
	reg carryin;
	FourAdder4bit add(out, cout, overflow, a, b);

	initial begin
		$display(" a   b   carryin |   Sum       Carryout | Expected sum   Expected Carryout|", a, b, carryin,out, cout);
		a = 4'b1111; b = 4'b0000; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1111                  0      |", a, b, carryin,out, cout);
		a = 4'b1001; b = 4'b0001; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1010                  0      |", a, b, carryin,out, cout);
		a = 4'b1011; b = 4'b0001; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1100                  0      |", a, b, carryin,out, cout);
		a = 4'b1111; b = 4'b0001; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0000                  1      |", a, b, carryin,out, cout);
		a = 4'b1111; b = 4'b0000; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1111                  0      |", a, b, carryin,out, cout);
		a = 4'b1111; b = 4'b1111; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1110                  1      |", a, b, carryin,out, cout);
		a = 4'b1001; b = 4'b0110; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1111                  0      |", a, b, carryin,out, cout);
		a = 4'b1010; b = 4'b1011; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1101                  0      |", a, b, carryin,out, cout);
		a = 4'b0111; b = 4'b0001; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1000                  0      |", a, b, carryin,out, cout);
		a = 4'b1000; b = 4'b1000; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0000                  1      |", a, b, carryin,out, cout);
		a = 4'b1010; b = 4'b1010; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0100                  1      |", a, b, carryin,out, cout);
		a = 4'b0111; b = 4'b1110; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0101                  1      |", a, b, carryin,out, cout);
		a = 4'b0001; b = 4'b0001; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0010                  0      |", a, b, carryin,out, cout);
		a = 4'b0010; b = 4'b0010; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0100                  0      |", a, b, carryin,out, cout);
		a = 4'b0100; b = 4'b0100; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1000                  0      |", a, b, carryin,out, cout);
		a = 4'b1001; b = 4'b1001; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    0010                  1      |", a, b, carryin,out, cout);
		a = 4'b0101; b = 4'b0101; carryin = 0; #1000
		$display(" %b   %b   %b    |   %b            %b   |    1010                  0      |", a, b, carryin,out, cout);
	end
endmodule


