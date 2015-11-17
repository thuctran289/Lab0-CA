module MIPSALU (ALUctl, A, B,ALUOut, Zero);
input [3:0]ALUctl;
input [31:0] A,B;
outputreg[31:0]ALUOut;
output Zero;
assign Zero = (ALUOut==0); //Zero is true ifALUOutis 0
always @(ALUctl, A, B) begin //reevaluate if these change
case (ALUctl)
0:ALUOut<= A & B;//and
1:ALUOut<= A | B;//or
2:ALUOut<= A + B;//add
6:ALUOut<= A -B;//subtract
7:ALUOut<= A < B ? 1 : 0;//slt
10:ALUOut<= A ^ B;//xor
11:ALUOut<= ~(A & B); //nand
12:ALUOut<= ~(A | B); //nor
default:ALUOut<= 0;
endcase
end
endmodule

module ALUControl(ALUOp,FuncCode,ALUCtl);
input [1:0]ALUOp;
input [5:0]FuncCode;
output [3:0]reg ALUCtl;
always case (FuncCode)
32:ALUCtl<=2; // add
34: ALUCtl<=6; //subtract
36: ALUCtl<=0; // and
38: ALUCtl<=11; //NAND
37: ALUCtl<=1; // or
39: ALUCtl<=12; // nor
40: ALUCtl<=10; //xor
42: ALUCtl<=7; //slt
default: ALUCtl<=15; // should not happen
endcase
endmodule