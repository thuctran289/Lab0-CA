module signextend(
	input [15:0] imm16,
	output [29:0] imm30
	);
wire [13:0] signimm[1:0];
assign signimm[0] = 0;
assign signimm[1] = -1;
wire [13:0] extend;
assign extend = signimm[imm16[15]];
assign imm30 = {extend, imm16};




endmodule