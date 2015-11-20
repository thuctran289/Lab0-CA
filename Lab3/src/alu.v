module MIPSALU (ALUctl, A, B, ALUOut, Zero);
    input [3:0] ALUctl;
    input [31:0] A,B;
    output reg [31:0] ALUOut;
    output Zero;
    assign Zero = (ALUOut==0); //Zero is true if ALUOut is 0; goes anywhere
    always @(ALUctl, A, B) //reevaluate if these change
    case (ALUctl)
    0: ALUOut <= A & B;
    1: ALUOut <= A | B;
    2: ALUOut <= A + B;
    6: ALUOut <= A - B;
    7: ALUOut <= A < B ? 1:0;
    10: ALUOut <= A ^ B ;
    12: ALUOut <= ~(A | B); // result is nor
    default: ALUOut <= 0; //default to 0, should not happen;
    endcase
endmodule


// test bench
module testALU;
    wire [31:0]out;
    wire Zero;
    reg [31:0]a;
    reg [31:0]b;
    reg [3:0]control;
  
    ALU alu(control, a, b, out, Zero);
  
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, testALU);


        $display("Command                  A                             B                  |                  R               | OFL CO     Zero |              Exp R               Exp OFL Exp CO Exp Zero");

        $display("                                                               ");
        $display("                            ADD Tests                          ");

        control=2; a=32; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000100001   0    0     0", control, a, b, out, overflow, cout, Zero); 
	control=2; a=2; b=3; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000101   0    0     0", control, a, b, out, overflow, cout, Zero);  
	control=2; a=-2147483648; b=2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   1    1     1", control, a, b, out, overflow, cout, Zero); 
	control=2; a=-8; b=2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, Zero); 
	control=2; a=8; b=-2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000110   0    1     0", control, a, b, out, overflow, cout, Zero);
	control=2; a=-8; b=-9; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111101111   0    1     0", control, a, b, out, overflow, cout, Zero);
	control=2; a=-8; b=2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, Zero);
        control=2; a=2147483648; b=2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   1    1     1", control, a, b, out, overflow, cout, Zero);
        control=2; a=-1; b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111110   0    1     0", control, a, b, out, overflow, cout, Zero);
	control=2; a=1; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000010   0    0     0", control, a, b, out, overflow, cout, Zero); 


        $display("                                                               ");
        $display("                            SUB Tests                          ");
        control=6; a=1; b=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000001   0    1     0", control, a, b, out, overflow, cout, Zero);
        control=6; a=1; b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111100001   0    0     0", control, a, b, out, overflow, cout, Zero);
	control=6; a=1; b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000100001   0    0     0", control, a, b, out, overflow, cout, Zero);
	control=6; a=-1; b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111011111   0    1     0", control, a, b, out, overflow, cout, Zero);
	control=6; a=-1; b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000011111   0    1     0", control, a, b, out, overflow, cout, Zero);
	control=6; a=-8; b=9; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111101111   0    1     0", control, a, b, out, overflow, cout, Zero);
	control=6; a=-8; b=-2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, Zero);
        control=6; a=2147483648; b=-2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   0    1     1", control, a, b, out, overflow, cout, Zero);
        control=6; a=-1; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111110   0    1     0", control, a, b, out, overflow, cout, Zero);

        $display("                                                               ");
        $display("                            XOR Tests                          ");
        control=10; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, Zero);
        control=10; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, Zero);
        control=10; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, Zero);
        control=10; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, Zero);

        $display("                                                               ");
        $display("                            SLT Tests                          ");
	control=7; a=32;b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, Zero);
	control=7; a=-32;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, Zero);
	control=7; a=32;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, Zero);
	control=7; a=1;b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, Zero);
	control=7; a=-32;b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, Zero);
	control=7; a=-1;b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, Zero);
	control=7; a=1;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, Zero);
	
    end
endmodule