module cpu();
reg clk;
wire[31:0] instruction;
wire RegDst, RegWr, ALUSrc, MemWr, MemToReg, branch, jump, jr, jal, zero;
wire [3:0] ALUcntrl;
wire [4:0] rs,rt,rd;
wire [15:0] imm16;
wire [25:0] jumpaddress;
wire [31:0] jraddress;
wire [29:0] add_res;

instructionfetch instFetch(clk, jumpaddress, imm16, jraddress, branch, zero, 1,jr, add_res, instruction);
datapath datPath(clk, rd, rs,rt, RegDst, RegWr, ALUSrc, ALUcntrl, MemWr,MemToReg, imm16, jal, add_res, jumpaddress, zero, jraddress);
instructiondecoder instde(instruction, RegDst, RegWr, ALUSrc, MemWr,  MemToReg, ALUcntrl, rs,rt,rd,imm16, jumpaddress, branch, jump, jr, jal);

endmodule