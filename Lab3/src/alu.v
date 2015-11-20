module alu(
	output reg [31:0] alu_res,
	input [31:0] a, b,
	input [1:0] op,
	input clk
);

always @(posedge clk) begin
	if (op == 0) begin
		assign alu_res = a + b;  //plus
	end else if (op == 1) begin
		assign alu_res = a - b;  //subtraction
	end else if (op == 2) begin
		assign alu_res = a ^ b;  //xor
	end else if (op == 3) begin
		assign alu_res = (a < b) ? 1 : 0;  //slt
 	end 
end

endmodule

// test bench
module testALU;
    wire [31:0]out;
    wire overflow, cout, zero;
    reg [31:0]a;
    reg [31:0]b;
    reg [1:0]control;
  
    ALU alu(out, a, b, control, clk);
  
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, testALU);


        $display("Command                  A                             B                  |                  R               | OFL CO     ZERO |              Exp R               Exp OFL Exp CO Exp Zero");

        $display("                                                               ");
        $display("                            ADD Tests                          ");

        control=3'b00; a=32; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000100001   0    0     0", control, a, b, out, overflow, cout, zero); 
	control=3'b00; a=2; b=3; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000101   0    0     0", control, a, b, out, overflow, cout, zero);  
	control=3'b00; a=-2147483648; b=2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   1    1     1", control, a, b, out, overflow, cout, zero); 
	control=3'b00; a=-8; b=2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, zero); 
	control=3'b00; a=8; b=-2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000110   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b00; a=-8; b=-9; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111101111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b00; a=-8; b=2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b00; a=2147483648; b=2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   1    1     1", control, a, b, out, overflow, cout, zero);
        control=3'b00; a=-1; b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111110   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b00; a=1; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000010   0    0     0", control, a, b, out, overflow, cout, zero); 


        $display("                                                               ");
        $display("                            SUB Tests                          ");
        control=3'b01; a=1; b=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000001   0    1     0", control, a, b, out, overflow, cout, zero);
        control=3'b01; a=1; b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111100001   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b01; a=1; b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000100001   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b01; a=-1; b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111011111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b01; a=-1; b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000011111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b01; a=-8; b=9; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111101111   0    1     0", control, a, b, out, overflow, cout, zero);
	control=3'b01; a=-8; b=-2; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111010   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b01; a=2147483648; b=-2147483648; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  00000000000000000000000000000000   0    1     1", control, a, b, out, overflow, cout, zero);
        control=3'b01; a=-1; b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  11111111111111111111111111111110   0    1     0", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            XOR Tests                          ");
        control=3'b10; b=0; a=0; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b10; b=1; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
        control=3'b10; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
        control=3'b10; b=0; a=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);

        $display("                                                               ");
        $display("                            SLT Tests                          ");
	control=3'b11; a=32;b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	control=3'b11; a=-32;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b11; a=32;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	control=3'b11; a=1;b=32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b11; a=-32;b=-1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  1   0    0     0", control, a, b, out, overflow, cout, zero);
	control=3'b11; a=-1;b=-32; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	control=3'b11; a=1;b=1; #10000
        $display("%b   %b  %b  | %b |  %b   %b    %b     |  0   0    0     1", control, a, b, out, overflow, cout, zero);
	
    end
endmodule