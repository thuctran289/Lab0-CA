module testinstructionfetch();
reg clk;
reg [25:0] Tinst;
reg [15:0] imm16;
reg branch, zero, jump, pc_we;
wire [29:0] address;

instructionfetch DUT(clk, Tinst, imm16, branch, zero, jump, pc_we, address);
initial clk = 0;
always #1 clk=!clk;

initial begin
	
        $dumpfile("instructionfetch.t.vcd");
        $dumpvars(0, testinstructionfetch);
        Tinst = 26'b00000000000000000000000000;
        imm16 = 16'b0000000000000000;
        branch = 0;
        zero = 0;
        jump = 0;
        pc_we = 1;
        #5
        Tinst = 5;
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