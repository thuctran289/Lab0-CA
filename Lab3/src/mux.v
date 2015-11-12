module mux2to1
(
	output		out,
	input 		address,
	input[1:0] 	inputs
);

	assign out = inputs[address];
	
endmodule