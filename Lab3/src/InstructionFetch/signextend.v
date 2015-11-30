module signextend
#(parameter out_width = 30,
	parameter in_width = 16
	)
(
	input [in_width-1:0] imm16,
	output [out_width-1:0] imm30
	);
wire [out_width-in_width-1:0] signimm[1:0];
assign signimm[0] = 0;
assign signimm[1] = -1;
wire [out_width-in_width-1:0] extend;
assign extend = signimm[imm16[in_width-1]];
assign imm30 = {extend, imm16};

endmodule
