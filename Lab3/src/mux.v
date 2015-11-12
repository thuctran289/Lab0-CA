module mux2to1
(
	output		out,
	input 		address,
	input[1:0] 	input0
);

	assign out = inputs[address];
	
endmodule