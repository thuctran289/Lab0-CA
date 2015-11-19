module instructiondecoder
(
	input [31:0] 		instruction,
	output reg			RegDst, // 0 = rt(i-type), 1 = rd(r-type)
	output reg			RegWr,
	output reg			AlUSrc, // 0= imm, 1=reg
	output reg			MemWr,
	output reg 			MemToReg, // 0 = ALU, 1 = mem
	output reg [3:0]	ALUcntrl,
	output reg [4:0]	rs,
	output reg [4:0]	rt,
	output reg [4:0]	rd,
	output reg [15:0]	imm16,
	output reg [25:0]	address,
	output reg 			branch,
	output reg 			jump,
	output reg 			jr,
	output reg 			jal
);

	parameter 	LW 		= 6'd35, // I-type OP codes
				SW 		= 6'd43,
				BNE 	= 6'd05,
				XORI	= 6'd14,

				J 		= 6'd02, // J-type OP codes
				JAL 	= 6'd03,

				R_TYPE 	= 6'd00, // R-type OP code

				JR 		= 6'd08, // R-type function codes
				ADD 	= 6'd32,
				SUB 	= 6'd34,
				SLT 	= 6'd42,

				ALU_AND	= 4'd00, // ALU cntrl
				ALU_OR	= 4'd01,
				ALU_ADD = 4'd02,
				ALU_SUB = 4'd06,
				ALU_SLT = 4'd07,
				ALU_XOR = 4'd10,
				ALU_NAND= 4'd11,
				ALU_NOR = 4'd12;


	reg [5:0] opcode, funct;

	always @(instruction) begin

		opcode 	= instruction[31:26];
		rs 		= instruction[25:21];
		rt 		= instruction[20:16];
		rd 		= instruction[15:11];
		funct 	= instruction[5:0];
		imm16	= instruction[15:0];
		address = instruction[25:0];
		branch	= 0;
		jump	= 0;
		jr 		= 0;
		jal 	= 0;


		case(opcode)
			LW: begin
				RegDst = 0;
				RegWr = 1;
				AlUSrc = 0;
				MemWr = 0;
				MemToReg = 1;
				ALUcntrl = ALU_ADD;
			end

			SW: begin
				RegDst = 0;//1'bx;
				RegWr = 0;
				AlUSrc = 0;
				MemWr = 1; //??
				MemToReg = 1; //???
				ALUcntrl = ALU_ADD;
			end

			BNE: begin
				RegDst = 0;//1'bx;
				RegWr = 0;
				AlUSrc = 1;
				MemWr = 0; //??
				MemToReg = 0; //???
				ALUcntrl = ALU_SUB;
				branch = 1;
			end

			XORI: begin
				// TODO
				RegDst = 0;
				RegWr = 1;
				AlUSrc = 0;
				MemWr = 0;
				MemToReg = 0; //???
				ALUcntrl = ALU_XOR;
			end

			J: begin
				// TODO
				RegDst = 0;//1'bx;
				RegWr = 0;//1'bx;
				AlUSrc = 0;//1'bx;
				MemWr = 0;
				MemToReg = 0; //???
				ALUcntrl = 4'b0;//4'bx;
				jump = 1;
			end

			JAL: begin
				// TODO
				RegDst = 0;
				RegWr = 1;
				AlUSrc = 0;//1'bx;
				MemWr = 0;
				MemToReg = 0;//1'bx; //???
				ALUcntrl = 4'b0;//4'bx;
				jump = 1;
				jal = 1;
				rt = 4'd31;
			end

			R_TYPE: begin
				case(funct)
					JR: begin
						// TODO
						RegDst = 0;//1'bx; //??
						RegWr = 0;//1'bx; //??
						AlUSrc = 0;//1'bx; //??
						MemWr = 0;		//??
						MemToReg = 0; //???
						ALUcntrl = 4'b0;//4'bx; //??
						jump = 1;
						jr = 1;
					end

					ADD: begin
						// TODO
						RegDst = 1;
						RegWr = 1;
						AlUSrc = 1;
						MemWr = 0;
						MemToReg = 0;
						ALUcntrl = ALU_ADD;
					end

					SUB: begin
						// TODO
						RegDst = 1;
						RegWr = 1;
						AlUSrc = 1;
						MemWr = 0;
						MemToReg = 0;
						ALUcntrl = ALU_SUB;
					end

					SLT: begin
						// TODO
						RegDst = 1;
						RegWr = 1;
						AlUSrc = 1;
						MemWr = 0;
						MemToReg = 0;
						ALUcntrl = ALU_SLT;
					end
				endcase
			end
		endcase
	end

endmodule