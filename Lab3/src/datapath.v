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
    input jal,
    input [29:0] jalAddr,
//    output [25:0] jumpAddr,
    output zero,
    output [31:0] read1

);

    wire [4:0] Aw;
    wire [31:0] Dw, dataMemMuxOut;
    wire [31:0] signextended;

    wire [31:0] read2, alu2in, ALUOut, memdOut;




    muxNby2to1 #(5) regdst(Aw, regDst, rt, rd);
    regfile registerfile(read1, read2, Dw, rs, rt, Aw, regWr, clk);
    assign jumpAddr = read1[27:2];
    muxNby2to1 #(32) alusrc(alu2in, ALUSrc, read2, signextended);
    signextend #(32,16) immsixteen(imm16, signextended);
    MIPSALU alu(ALUcntrl, read1, alu2in, ALUOut, zero);

    memory datamem(clk, memWr, ALUOut, read2, memdOut);
    muxNby2to1 #(32) muxmemtoreg(dataMemMuxOut, memToReg, ALUOut, memdOut);

    muxNby2to1 #(32) jalMux(Dw, jal, dataMemMuxOut, {jalAddr, 2'b00});


endmodule