module datapath
(    
	input clk, 
    input [4:0] rd, rs, rt,
	input regDst,
	input regWr, 
     input ALUSrc,
    input [3:0] ALUcntrl,
     input memWr,
    input memToReg,
    input [15:0] imm16,
    output zero

)

wire Aw;
wire Dw;
wire signextended;

wire [31:0] read1, read2, alu2in, ALUOut;



muxNby2to1 #(5) regdst(Aw, RegDst, rd, rt);
registerfile regfile(read1, read2, Dw, rs, rt, regWr, clk);
muxNby2to1 #(32) alusrc(alu2in, ALUSrc, read2, signextended);
signextend #(32,16) immsixteen(imm16, signextended);
MIPSALU alu(ALUcntrl, read1, alu2in, ALUOut, zero);


endmodule