//Delays 
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50
module behavioralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
output out, carryout;
input a, b, carryin;
wire aXorb,bOrC, aAndBorC, bAndc;

//Two xors used for determining the output sum. 
`XOR aXorbgate(aXorb, a, b);
`XOR aXorbXorcgate(out, aXorb, carryin);

//Used for determining the Carryout value. 
`OR bOrcgate(bOrC, b, carryin);
`AND aAndbOrCgate(aAndBorC, bOrC, a);
`AND bAndcgate(bAndc, b,carryin);
`OR cout(carryout, bAndc, aAndBorC);

endmodule

module testFullAdder;
reg a, b, carryin;
wire sum, carryout;
structuralFullAdder adder (sum, carryout, a, b, carryin);

initial begin

$display("Cin  a   b |  Sum  Cout | Exp Sum  Exp Cout");
a = 0; b = 0; carryin= 0; #2000
$display(" %b   %b   %b |   %b    %b   |    0        0", carryin, b, a, sum, carryout);
a = 0; b = 1; carryin= 0; #2000
$display(" %b   %b   %b |   %b    %b   |    1        0", carryin, b, a, sum, carryout);
a = 1; b = 0; carryin= 0; #2000
$display(" %b   %b   %b |   %b    %b   |    1        0", carryin, b, a, sum, carryout);
a = 1; b = 1; carryin= 0; #2000
$display(" %b   %b   %b |   %b    %b   |    0        1", carryin, b, a, sum, carryout);
a = 0; b = 0; carryin= 1; #2000
$display(" %b   %b   %b |   %b    %b   |    1        0", carryin, b, a, sum, carryout);
a = 0; b = 1; carryin= 1; #2000
$display(" %b   %b   %b |   %b    %b   |    0        1", carryin, b, a, sum, carryout);
a = 1; b = 0; carryin= 1; #2000
$display(" %b   %b   %b |   %b    %b   |    0        1", carryin, b, a, sum, carryout);
a = 1; b = 1; carryin= 1; #2000
$display(" %b   %b   %b |   %b    %b   |    1        1", carryin, b, a, sum, carryout);
end
endmodule