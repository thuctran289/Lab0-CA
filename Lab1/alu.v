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
        output reg sltSet
    );

    always @(ALUcommand) begin
        case (ALUcommand)
            `ADDo:  begin muxindex = 0; invertB=0; sltSet=0; end    
            `SUBo:  begin muxindex = 0; invertB=1; sltSet=0; end
            `XORo:  begin muxindex = 1; invertB=0; sltSet=0; end    
            `SLTo:  begin muxindex = 0; invertB=1; sltSet=1; end
            `ANDo:  begin muxindex = 3; invertB=0; sltSet=0; end    
            `NANDo: begin muxindex = 4; invertB=0; sltSet=0; end
            `NORo:  begin muxindex = 5; invertB=0; sltSet=0; end    
            `ORo:   begin muxindex = 6; invertB=0; sltSet=0; end
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
    wire sltRes;
    wire [31:0]sltResult;
    wire sltSameSign, sltOppTemp, sltOpp, notOverflow, sltChoice;
    ALUcontrolLUT aluControlLUT(deviceChoice,bInv,command, sltChoice);

    // connect 32 ALU bit slices
    genvar i;
    generate
        for (i=0; i < 32; i=i+1) begin : ALUbit
            if (i == 0)
                begin
                    `OR(carry[i], 0, bInv);
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

    // Carryout flag logic
    `NOT(notCommand2, command[2]);
    `NOT(notCommand1, command[1]);
    `ANDtri (carryout, carry[32], notCommand1, notCommand2);
    
    // Overflow flag logic
    ourXOR ourxor(tempOverflow, carry[31], carryout);
    `ANDtri (overflow, tempOverflow, notCommand1, notCommand2);

    // SLT
    `NOT(notOverflow, tempOverflow);
    `AND(sltOppTemp, tempresult[31], tempOverflow);
    `AND(sltOpp, sltOppTemp, operandA[31]);

    `AND(sltSameSign, tempresult[31], notOverflow);
    `OR(sltResult[0], sltSameSign, sltOpp);

    // 0s for 31 most significant bits for SLT result
    genvar j;
    generate
        for (j=1; j < 32; j=j+1) begin : ANDGenerator
            `AND(sltResult[j], 0, 0);
        end
    endgenerate

    // Mux the result of SLT and result of the ALU bit slices to choose which result to output
    thirtyTwoMux mux32(result, tempresult, sltResult, sltChoice);

    
    // ZERO flag logic
    `OR32(tempZero, result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15],result[16],result[17],result[18],result[19],result[20],result[21],result[22],result[23],result[24],result[25],result[26],result[27],result[28],result[29],result[30],result[31]);
    `NOT(zero, tempZero);


endmodule

// Bit-slice of ALU
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
    
    eightToOneMux eightonemux(aADDb,aXORb,1'b0,  aANDb,aNANDb ,aNORb,aORb ,aANDb, muxDevice, out );

endmodule

// XOR made of basic gates
module ourXOR(output out, input a, input b);
	wire AnorB, AorB, AnandB, notXOR;
	
	`NOR(AnorB, a, b);
	`NOT(AorB, AnorB);
	`NAND(AnandB, a, b);
	`NAND(notXOR, AnandB, AorB);
    `NOT(out, notXOR);
endmodule

// Two to one mux for choosing B or Binv (important for subtraction)
module twoToOneMux(output out, input address, input in0, input in1);
	wire nAddr, in0nandnAddr, in1nandAddr;
	
	`NOT(nAddr, address);
	`NAND(in0nandnAddr, in0, nAddr);
	`NAND(in1nandAddr, in1, address);
	`NAND(out, in0nandnAddr, in1nandAddr);
endmodule 

// Mux for choosing output of ALU bit slice
module eightToOneMux(input in0, input in1, input in2, input in3, input in4,input in5, input in6,input in7, input[2:0] addr, output out );
    wire temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, naddr0, naddr1, naddr2;
    `NOT(naddr0, addr[0]);
    `NOT(naddr1, addr[1]);
    `NOT(naddr2, addr[2]);


    `bAND(temp0, naddr0, naddr1, naddr2, in0);
    `bAND(temp1, addr[0], naddr1, naddr2, in1);
    `bAND(temp2, naddr0, addr[1], naddr2, in2);
    `bAND(temp3, addr[0], addr[1], naddr2, in3);
    `bAND(temp4, naddr0, naddr1, addr[2], in4);
    `bAND(temp5, addr[0], naddr1, addr[2], in5);
    `bAND(temp6, naddr0, addr[1], addr[2], in6);
    `bAND(temp7, addr[0], addr[1], addr[2], in7);

    `bOR(out, temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7);
endmodule

// Mux two 32-bit wires to choose if final output is result of SLT or result of ALU bits
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

// test bench
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


        $display("Command                  A                             B                  |                  R               | OFL CO     ZERO |              Exp R               Exp OFL Exp CO Exp Zero");

        $display("                                                               ");
        $display("                            ADD Tests                          ");

        control=3'b000; a=32; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000100001   0    0     0", control, a, b, out, overflow, cout, zero); 
	control=3'b000; a=2; b=3; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000101   0    0     0", control, a, b, out, overflow, cout, zero);  
	control=3'b000; a=-2147483648; b=2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   1    1     1", control, a, b, out, overflow, cout, zero); 
	control=3'b000; a=-8; b=2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, zero); 
	control=3'b000; a=8; b=-2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000110   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b000; a=-8; b=-9; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111101111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b000; a=-8; b=2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b000; a=2147483648; b=2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   1    1     1", control, a, b, out, overflow, cout, zero);
        control=3'b000; a=-1; b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111110   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b000; a=1; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000010   0    0     0", control, a, b, out, overflow, cout, zero); 


        $display("                                                               ");
        $display("                            SUB Tests                          ");
        control=3'b001; a=1; b=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000001   0    1     0", control, a, b, out, overflow, cout, zero);
        control=3'b001; a=1; b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111100001   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b001; a=1; b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000100001   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b001; a=-1; b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111011111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b001; a=-1; b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000011111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b001; a=-8; b=9; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111101111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b001; a=-8; b=-2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b001; a=2147483648; b=-2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   0    1     1", control, a, b, out, overflow, cout, zero);
        control=3'b001; a=-1; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111110   0    1     0", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            XOR Tests                          ");
        control=3'b010; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b010; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b010; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b010; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            SLT Tests                          ");
	control=3'b011; a=32;b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	control=3'b011; a=-32;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b011; a=32;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	control=3'b011; a=1;b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b011; a=-32;b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b011; a=-1;b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	control=3'b011; a=1;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	
        $display("                                                               ");
        $display("                            AND Tests                          ");
        control=3'b100; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b100; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b100; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b100; b=1; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                           NAND Tests                          ");
        control=3'b101; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b101; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all1, last 0   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b101; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b101; b=1; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1   0    0     0", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            NOR Tests                          ");
        control=3'b110; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b110; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1, last 0   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b110; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1, last 0   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b110; b=1; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  all 1, last 0   0    0     0", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                             OR Tests                          ");
        control=3'b111; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b111; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b111; b=1; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b111; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);

    end
endmodule
