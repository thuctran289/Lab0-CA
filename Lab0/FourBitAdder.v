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
a = 5; b = 9; carryin = 0; #1000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, out, cout);
a = 5; b = 15; carryin = 0; #1000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, out, cout);
a = 1; b = 15; carryin = 0; #1000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, out, cout);
a = 0; b = 15; carryin = 1; #1000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, out, cout);
a = 15; b = 0; carryin = 1; #1000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, out, cout);
a = 15; b = 15; carryin = 1; #1000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, out, cout);

end
endmodule


