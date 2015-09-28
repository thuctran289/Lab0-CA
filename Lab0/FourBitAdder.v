//Delays 
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50

module FullAdder4bit
(
	output [3:0] sum, 
	output carryout, 
	output overflow,
	input[3:0] a,
	input[3:0] b
);

wire c0, c1,c2;
structuralFullAdder adder0 (sum[0], c0, a[0], b[0], 0);
structuralFullAdder adder1 (sum[1], c1, a[1], b[1], c0);
structuralFullAdder adder2 (sum[2], c2, a[2], b[2], c1);
structuralFullAdder adder3 (sum[3], carryout, a[3], b[3], c2);

`XOR(overflow, c2, carryout);


endmodule

module test4BitAdd;
wire [3:0]out;
wire cout;
reg [3:0] a;
reg [3:0] b;
reg carryin;
FourBitFullAdder add(out, cout,overflow, a,b);

initial begin
a = 5; b = 9;  #1000
$display(" %b   %b   %b |   %b      |    0        0", b, a, out, cout);
a = 5; b = 15;  #1000
$display(" %b   %b   %b |   %b      |    0        0", b, a, out, cout);
a = 1; b = 15;  #1000
$display(" %b   %b   %b |   %b      |    0        0", b, a, out, cout);
a = 0; b = 15;  #1000
$display(" %b   %b   %b |   %b      |    0        0",  b, a, out, cout);
a = 15; b = 0;  #1000
$display(" %b   %b   %b |   %b      |    0        0",  b, a, out, cout);
a = 15; b = 15; #1000
$display(" %b   %b   %b |   %b      |    0        0",  b, a, out, cout);

end
endmodule


