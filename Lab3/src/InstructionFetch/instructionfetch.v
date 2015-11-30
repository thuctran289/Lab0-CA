module instructionfetch
(
	input clk,
	input [25:0] j_tinst,
	input [15:0] imm16,
	input [31:0] jr_tinst,
	input branch, 
	input zero, 
	input jump,
	input pc_we,
	input jr,
	output [29:0] add_res,
	output [31:0] instruction
);


	wire [31:0] current_PC;
	wire [31:0] next_PC;
	wire [29:0] concat_res;
	wire [29:0] branch_coord;
	wire [29:0] imm30;
	wire [25:0] TInst;
	wire branchAndzero;
	wire [29:0] address;
	wire nbranchAndzero;
	wire nZero;
	not (nZero, zero);

//	initial concat_res = 30'b000000000000000000000000000000;
//	initial next_PC = 30'b000000000000000000000000000000;
	and add(branchAndzero, branch, nZero);
	assign next_PC[1:0] = 2'b00;
	not (nbranchAndzero, branchAndzero);
	muxNby2to1 #(26) tinstchoice(TInst, jr, j_tinst, jr_tinst[27:2]);
	programcounter PC(clk, next_PC, pc_we, current_PC);
	concatenate concat(current_PC[31:28], TInst, concat_res);
	signextend signext(imm16, imm30);
	muxNby2to1 #(30) brancher(branch_coord, branchAndzero, 30'b000000000000000000000000000000, imm30);
	FullAdder30 PC_Step(add_res, current_PC[31:2], branch_coord,nbranchAndzero);
	muxNby2to1 #(30) jumpmachine(next_PC[31:2], jump, add_res,concat_res);
	assign address = current_PC[31:2];
	instructionmemory programMem(clk, 0, {2'b00,address}, 0,instruction);


endmodule