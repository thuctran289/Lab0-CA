//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module registerfile
(
	output[31:0]	ReadData1,	// Contents of first register read
	output[31:0]	ReadData2,	// Contents of second register read
	input[31:0]		WriteData,	// Contents to write to register
	input[4:0]		ReadRegister1,	// Address of first register to read
	input[4:0]		ReadRegister2,	// Address of second register to read
	input[4:0]		WriteRegister,	// Address of register to write
	input			RegWrite,	// Enable writing of register when High
	input			Clk		// Clock (Positive Edge Triggered)
);
	wire[31:0] wrenable;
	decoder1to32 decoder(wrenable, RegWrite, WriteRegister);

	wire[31:0] regOut[31:0];
	register32zero regZero(regOut[0], WriteData, wrenable[0], Clk);

	genvar i;
	generate
		for (i=1; i<32; i=i+1) begin : regGenerator
			register32 reg32(regOut[i], WriteData, wrenable[i], Clk);
		end
	endgenerate
	mux32to1by32 mux1(ReadData1, ReadRegister1, regOut[0], regOut[1], regOut[2], regOut[3], regOut[4], regOut[5], regOut[6], regOut[7], regOut[8], regOut[9], regOut[10], regOut[11], regOut[12], regOut[13], regOut[14], regOut[15], regOut[16], regOut[17], regOut[18], regOut[19], regOut[20], regOut[21], regOut[22], regOut[23], regOut[24], regOut[25], regOut[26], regOut[27], regOut[28], regOut[29], regOut[30], regOut[31]);
	mux32to1by32 mux2(ReadData2, ReadRegister2, regOut[0], regOut[1], regOut[2], regOut[3], regOut[4], regOut[5], regOut[6], regOut[7], regOut[8], regOut[9], regOut[10], regOut[11], regOut[12], regOut[13], regOut[14], regOut[15], regOut[16], regOut[17], regOut[18], regOut[19], regOut[20], regOut[21], regOut[22], regOut[23], regOut[24], regOut[25], regOut[26], regOut[27], regOut[28], regOut[29], regOut[30], regOut[31]);

endmodule
