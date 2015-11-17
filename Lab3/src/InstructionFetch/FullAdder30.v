module FullAdder30(
output[29:0] result,
input [29:0] a,b,
input cin
);
assign result = a+b+cin;

endmodule