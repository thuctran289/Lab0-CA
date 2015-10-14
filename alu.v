`define ADDo  3'd0
`define SUBo  3'd1
`define XORo  3'd2
`define SLTo  3'd3
`define ANDo  3'd4
`define NANDo 3'd5
`define NORo  3'd6
`define ORo   3'd7
`define NOR nor #20
`define NOT not #10
`define NAND nand #20
`define AND and #30
`define OR or #30
`define bAND and #50
`define bOR or #90


module ALUcontrolLUT
  (
  output reg[2:0]     muxindex,
  output reg  invertB,
  input[2:0]  ALUcommand
  );

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADDo:  begin muxindex = 0; invertB=0; end    
      `SUBo:  begin muxindex = 0; invertB=1; end
      `XORo:  begin muxindex = 1; invertB=0; end    
      `SLTo:  begin muxindex = 0; invertB=1; end
      `ANDo:  begin muxindex = 3; invertB=0; end    
      `NANDo: begin muxindex = 4; invertB=0; end
      `NORo:  begin muxindex = 5; invertB=0; end    
      `ORo:   begin muxindex = 6; invertB=0; end
    endcase
  end
endmodule







module ALU
(
output[31:0]    result,
output          carryout,
output          zero,
output          overflow,
input[31:0]     operandA,
input[31:0]     operandB,
input[2:0]      command
);
  wire bInv;
  wire [2:0] deviceChoice;
  wire [31:0] carry; 
  ALUcontrolLUT aluControlLUT(deviceChoice,bInv,command);

  genvar i;
  generate
    for (i=0; i < 32; i=i+1) begin : ALUbit
      if (i == 0)
        begin
          assign carry[i] = bInv;
          structuralALU strucALU(result[i], carry[i+1], operandA[i],operandB[i], carry[i], bInv, deviceChoice); 
      end else if (i == 31) 
        begin
          structuralALU sALU(result[i], carryout, operandA[i],operandB[i], carry[i], bInv, deviceChoice); 
      end else 
        begin
          structuralALU structureALU(result[i], carry[i+1], operandA[i],operandB[i], carry[i], bInv, deviceChoice);
        end
      end
  endgenerate

  ourXOR ourxor(overflow, carry[31], carryout);


endmodule













module structuralALU(output out,
   output carryout,
   input a,
   input b,
   input carryin,
   input bInvert,
 		 	   input[0:2] muxDevice);
wire aXORb, bInv, bChoice, aXORb_AND_Carryin, aNANDb, aANDb, aADDb, aNORb, aORb, aXORb_AND_Carryin__nor__aAndb;
//This covers the NOR and OR cases.
`NOR(aNORb, a,b);
`NOT(aORb, aNORb);

//B inversion + selecting addition vs. subtraction set up. 
`NOT(bInv, b);
twoToOneMux twooneMux(bChoice, bInvert, b, bInv);

//XOR Component
ourXOR ourXor(aXORb, a,bChoice);
// Addition/Subtraction element
ourXOR oXOR(aADDb, aXORb, carryin);

// NAND and AND components.
`NAND(aNANDb, a,bchoice);
`NOT(aANDb, aNANDb);

// carryout Component
`AND(aXORb_AND_carryin, aXORb, carryin);
`NOR(aXORb_AND_Carryin__nor__aAndb, aXORb_AND_carryin, aANDb);
`NOT(carryout,  aXORb_AND_Carryin__nor__aAndb);


endmodule

module ourXOR(output out, input a, input b);
	wire AnorB, AorB, AnandB, notXOR;
	
	`NOR(AnorB, a, b);
	`NOT(AorB, AnorB);
	`NAND(AnandB, a, b);
	`NAND(notXOR, AnandB, AorB);
  `NOT(out, notXOR);
endmodule

module twoToOneMux(output out, input address, input in0, input in1);
	wire nAddr, in0nandnAddr, in1nandAddr;
	
	`NOT(nAddr, address);
	`NAND(in0nandnAddr, in0, nAddr);
	`NAND(in1nandAddr, in1, address);
	`NAND(out, in0nandnAddr, in1nandAddr);
endmodule 



module eightToOneMux(input in0, input in1, input in2, input in3, input in4,input in5, input in6,input in7, input[2:0] addr, output out );
wire temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, naddr0, naddr1, naddr2, nnaddr0, nnaddr1, nnaddr2;
`NOT(naddr0, addr[0]);
`NOT(naddr1, addr[1]);
`NOT(naddr2, addr[2]);
`NOT(nnaddr0, naddr0);
`NOT(nnaddr1, naddr1);
`NOT(nnaddr2, naddr2);

`bAND(temp0, naddr0, naddr1, naddr2, in0);
`bAND(temp1, nnaddr0, naddr1, naddr2, in1);
`bAND(temp2, naddr0, nnaddr1, naddr2, in2);
`bAND(temp3, nnaddr0, naddr1, naddr2, in3);
`bAND(temp4, naddr0, naddr1, nnaddr2, in4);
`bAND(temp5, nnaddr0, naddr1, nnaddr2, in5);
`bAND(temp6, naddr0, nnaddr1, nnaddr2, in6);
`bAND(temp7, nnaddr0, nnaddr1, nnaddr2, in7);

`bOR(out, temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7);
endmodule



module testALU;
  wire [31:0]out;
  wire overflow, cout, zero;
  reg [31:0]a;
  reg [31:0]b;
  reg [2:0]control;
  
  ALU alu(out, cout, zero, overflow, a, b, control);
  
initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, testALU);

$display("Control B A | R | OFL CO ZERO | Exp R Exp OFL Exp CO Exp Zero");

$display("                                                               ");
$display("                            ADD Tests                          ");

control=3'b000; b=0; a=0; #10000
$display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, b, a, out, overflow, cout, zero);
control=3'b000; b=32; a=32; #10000
$display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, b, a, out, overflow, cout, zero);

  

  $display("                                                               ");
$display("                            SUB Tests                          ");

$display("                                                               ");
$display("                            XOR Tests                          ");

$display("                                                               ");
$display("                            SLT Tests                          ");

$display("                                                               ");
$display("                            AND Tests                          ");

$display("                                                               ");
$display("                           NAND Tests                          ");

$display("                                                               ");
$display("                            NOR Tests                          ");

$display("                                                               ");
$display("                             OR Tests                          ");


  end
endmodule