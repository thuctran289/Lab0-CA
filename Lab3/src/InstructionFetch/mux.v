module mux2to1
(
	output		out,
	input 		address,
	input[1:0] 	inputs
);

	assign out = inputs[address];
	
endmodule


module mux16by2to1
(
	output [15:0] out,
	input address,
	input [15:0] inputs0, inputs1
	);
wire [15:0] inputs[1:0];
assign inputs[1] = inputs1;
assign inputs[0] = inputs0;

assign out = inputs[address];



endmodule