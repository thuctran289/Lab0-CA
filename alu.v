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
`define ANDtri and #40
`define OR32 or #330

// LUT to control the inputs of the ALU (the mux command and ~B)
module ALUcontrolLUT (
        output reg[2:0]     muxindex,
        output reg  invertB,
        input[2:0]  ALUcommand,
        output reg[31:0] sltResult,
        output reg sltSet
    );

    always @(ALUcommand) begin
        case (ALUcommand)
            `ADDo:  begin muxindex = 0; invertB=0;  sltResult=0; sltSet=0; end    
            `SUBo:  begin muxindex = 0; invertB=1;  sltResult=0; sltSet=0; end
            `XORo:  begin muxindex = 1; invertB=0;  sltResult=0; sltSet=0; end    
            `SLTo:  begin muxindex = 0; invertB=1;  sltResult=0; sltSet=1; end
            `ANDo:  begin muxindex = 3; invertB=0;  sltResult=0; sltSet=0; end    
            `NANDo: begin muxindex = 4; invertB=0;  sltResult=0; sltSet=0; end
            `NORo:  begin muxindex = 5; invertB=0;  sltResult=0; sltSet=0; end    
            `ORo:   begin muxindex = 6; invertB=0;  sltResult=0; sltSet=0; end
        endcase
    end
endmodule

// Overall ALU 32-bit ALU, complete with control LUT
module ALU (
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
    wire [32:0] carry;
    wire [31:0] tempresult;
    wire notCommand2, notCommand1;
    wire tempOverflow;
    wire tempZero;
    wire [31:0] sltResult;
    wire sltSameSign, sltOppTemp, sltOpp, notOverflow, sltChoice;
    ALUcontrolLUT aluControlLUT(deviceChoice,bInv,command, sltResult, sltChoice);

    genvar i;
    generate
        for (i=0; i < 32; i=i+1) begin : ALUbit
            if (i == 0)
                begin
                    assign carry[i] = bInv;
                    structuralALU strucALU(tempresult[i], carry[i+1], operandA[i],operandB[i], carry[i], bInv, deviceChoice); 
            end else if (i == 31) 
                begin
                    structuralALU sALU(tempresult[i], carry[i+1], operandA[i],operandB[i], carry[i], bInv, deviceChoice); 
            end else 
                begin
                    structuralALU structureALU(tempresult[i], carry[i+1], operandA[i],operandB[i], carry[i], bInv, deviceChoice);
            end
        end
    endgenerate
    `NOT(notCommand2, command[2]);
    `NOT(notCommand1, command[1]);
    `ANDtri (carryout, carry[32], notCommand1, notCommand2);
    ourXOR ourxor(tempOverflow, carry[31], carryout);
    `ANDtri (overflow, tempOverflow, notCommand1, notCommand2);

    // SLT
    `NOT(notOverflow, tempOverflow);
    `AND(sltOppTemp, tempresult[31], overflow);
    `AND(sltOpp,sltOppTemp, operandA[31]);
    `AND(sltSameSign, tempresult[31], notOverflow);
    `OR(sltResult[0], sltSameSign, sltOpp);

    thirtyTwoMux mux32(result, tempresult, sltResult, sltChoice);

    

    `OR32(tempZero, result);
    `NOT(zero, tempZero);


endmodule

module structuralALU(
        output out,
        output carryout,
        input a,
        input b,
        input carryin,
        input bInvert,
        input[2:0] muxDevice
    );

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
    `NAND(aNANDb, a,bChoice);
    `NOT(aANDb, aNANDb);

    // carryout Component
    `AND(aXORb_AND_carryin, aXORb, carryin);
    `NOR(aXORb_AND_Carryin__nor__aAndb, aXORb_AND_carryin, aANDb);
    `NOT(carryout,  aXORb_AND_Carryin__nor__aAndb);
    
    eightToOneMux eightonemux(aADDb, aXORb, 0, aANDb,aNANDb ,aNORb,aORb ,0, muxDevice, out );

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

module thirtyTwoMux(output [31:0]out, input [31:0]in1, input [31:0]in2, input selector);
    wire notSelector;
    wire [31:0]andIn1;
    wire [31:0]andIn2;

    `NOT(notSelector, selector);
    genvar i;
    generate
        for (i=0; i < 32; i=i+1) begin : ANDGenerator
            `AND(andIn1[i], in1[i], notSelector);
            `AND(andIn2[i], in2[i], selector);
            `OR(out[i], andIn1[i], andIn2[i]);
        end
    endgenerate

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

        $display("Result A B | R | OFL CO ZERO | Exp R Exp OFL Exp CO Exp Zero");

        $display("                                                               ");
        $display("                            ADD Tests                          ");

        control=3'b000; a=2147483648; b=2147483648; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b000; a=32; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);

          

        $display("                                                               ");
        $display("                            SUB Tests                          ");
        control=3'b001; b=0; a=1; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b001; b=32; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);


        $display("                                                               ");
        $display("                            XOR Tests                          ");
        control=3'b010; b=0; a=0; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b010; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            SLT Tests                          ");

        $display("                                                               ");
        $display("                            AND Tests                          ");
        control=3'b100; b=0; a=0; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b100; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                           NAND Tests                          ");
        control=3'b101; b=0; a=0; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b101; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            NOR Tests                          ");
        control=3'b110; b=0; a=0; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b110; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        
        $display("                                                               ");
        $display("                             OR Tests                          ");
        control=3'b111; b=0; a=0; #10000
        $display(" %b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b111; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);

    end
endmodule