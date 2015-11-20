module testinstructionfetch();
reg clk;
reg [25:0] j_Tinst;
reg [15:0] imm16;
reg [31:0] jr_tinst;
reg jr;
reg branch, zero, jump, pc_we;
wire [29:0] add_res;
wire [31:0] instruction;

instructionfetch DUT(clk, j_Tinst, imm16, jr_tinst,  branch, zero, jump, pc_we, jr, add_res, instruction);
initial clk = 0;
always #1 clk=!clk;

initial begin
	
        $dumpfile("instructionfetch.t.vcd");
        $dumpvars(0, testinstructionfetch);
        j_Tinst = 26'b00000000000000000000000000;
        imm16 = 16'b0000000000000000;
        jr = 0;
        branch = 0;
        zero = 0;
        jump = 0;
        pc_we = 1;
        #5
        j_Tinst = 5;
        jump = 1;
        #1
        jump = 0;
        #10
        branch = 1;
        imm16 = 4;
        zero = 1;
        #5
        zero = 0;
        branch = 0;
        jump = 1;
        #10;
        jump = 0;
        branch = 1;
        #1;
        branch  =0;
        #10;
	$finish;
end




endmodule