module mux2to1
(
	output		out,
	input 		address,
	input[1:0] 	inputs
);

	assign out = inputs[address];
	
endmodule


module muxNby2to1
#(parameter width = 16)
(
	output [width-1:0] out,
	input address,
	input [width-1:0] inputs0, inputs1
	);
wire [width-1:0] inputs[1:0];
assign inputs[1] = inputs1;
assign inputs[0] = inputs0;

assign out = inputs[address];

endmodule