module cpu(clk);
	input clk;
	wire[31:0] instruction;
	wire RegDst, RegWr, ALUSrc, MemWr, MemToReg, branch, jump, jr, jal, zero;
	wire [3:0] ALUcntrl;
	wire [4:0] rs,rt,rd;
	wire [15:0] imm16;
	wire [25:0] jumpaddress, jumpaddress1;
	wire [31:0] jraddress, jraddress1;
	wire [29:0] add_res;
	assign jraddress1 = 32'd0;
	assign jumpaddress1 = 26'd4;

	instructiondecoder instde(instruction, RegDst, RegWr, ALUSrc, MemWr,  MemToReg, ALUcntrl, rs,rt,rd,imm16, jumpaddress, branch, jump, jr, jal);	
	instructionfetch instFetch(clk, jumpaddress1, imm16, jraddress1, branch, zero, jump, 1, jr, add_res, instruction);
	// instructiondecoder instde(instruction, RegDst, RegWr, ALUSrc, MemWr,  MemToReg, ALUcntrl, rs,rt,rd,imm16, jumpaddress, branch, jump, jr, jal);
	datapath datPath(clk, rd, rs,rt, RegDst, RegWr, ALUSrc, ALUcntrl, MemWr,MemToReg, imm16, jal, add_res, jumpaddress, zero, jraddress);
	

endmodule
