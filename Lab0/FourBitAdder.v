//Delays 
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50

module FourBitFullAdder(out, cout, a, b, carryin);

output [3:0]out;
output cout;
input [3:0] a;
input [3:0] b;
input carryin;
wire c0, c1,c2;
structuralFullAdder adder0 (out[0], c0, a[0], b[0], carryin);
structuralFullAdder adder1 (out[1], c1, a[1], b[1], c0);
structuralFullAdder adder2 (out[2], c2, a[2], b[2], c1);
structuralFullAdder adder3 (out[3], cout, a[3], b[3], c2);

endmodule

module test4BitAdd;
wire [3:0]out;
wire cout;
reg [3:0] a;
reg [3:0] b;
reg carryin;
FourBitFullAdder add(out, cout, a,b,carryin);

initial begin
$display(" a   b   carryin |   Sum       Carryout | Expected sum   Expected Carryout|", a, b, carryin,out, cout);
a = 1111; b = 0000; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1111                  0      |", a, b, carryin,out, cout);
a = 1001; b = 0001; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1010                  0      |", a, b, carryin,out, cout);
a = 1011; b = 0001; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1100                  0      |", a, b, carryin,out, cout);
a = 1111; b = 0001; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0000                  1      |", a, b, carryin,out, cout);
a = 1111; b = 0000; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1111                  0      |", a, b, carryin,out, cout);
a = 1111; b = 1111; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1110                  1      |", a, b, carryin,out, cout);
a = 1001; b = 0110; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1111                  0      |", a, b, carryin,out, cout);
a = 1010; b = 1011; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1101                  0      |", a, b, carryin,out, cout);
a = 0111; b = 0001; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1000                  0      |", a, b, carryin,out, cout);
a = 1000; b = 1000; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0000                  1      |", a, b, carryin,out, cout);
a = 1010; b = 1010; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0100                  1      |", a, b, carryin,out, cout);
a = 0111; b = 1110; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0101                  1      |", a, b, carryin,out, cout);
a = 0001; b = 0001; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0010                  0      |", a, b, carryin,out, cout);
a = 0010; b = 0010; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0100                  0      |", a, b, carryin,out, cout);
a = 0100; b = 0100; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1000                  0      |", a, b, carryin,out, cout);
a = 1001; b = 1001; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    0010                  1      |", a, b, carryin,out, cout);
a = 0101; b = 0101; carryin = 0; #1000
$display(" %b   %b   %b    |   %b            %b   |    1010                  0      |", a, b, carryin,out, cout);
end
endmodule


