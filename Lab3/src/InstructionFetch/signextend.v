module signextend(
	input [15:0] imm16,
	output [31:0] imm32
	);
wire [15:0] signimm[1:0];
assign signimm[0] = 0;
assign signimm[1] = -1;
wire [15:0] extend;
assign extend = signimm[imm16[15]];
assign imm32 = {extend, imm16};




endmodule