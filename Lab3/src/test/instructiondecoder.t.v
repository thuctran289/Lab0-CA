module testinstructiondecoder();

	reg [31:0] 	instruction;
	wire		RegDst; // 0 = rt(i-type), 1 = rd(r-type)
	wire		RegWr;
	wire		AlUSrc; // 0= imm, 1=reg
	wire		MemWr;
	wire 		MemToReg; // 0 = ALU, 1 = mem
	wire [3:0]	ALUcntrl;
	wire [4:0]	rs;
	wire [4:0]	rt;
	wire [4:0]	rd;
	wire [15:0]	imm16;
	wire [25:0]	address;
	wire 		branch;
	wire 		jump;
	wire 		jr;
	wire 		jal;

	instructiondecoder dut
	(
		.instruction(instruction),
		.RegDst(RegDst),
		.RegWr(RegWr),
		.AlUSrc(AlUSrc),
		.MemToReg(MemToReg),
		.ALUcntrl(ALUcntrl),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.imm16(imm16),
		.address(address),
		.branch(branch),
		.jump(jump),
		.jr(jr),
		.jal(jal)
	);

	reg dutpassed;
	integer i;

	initial begin
		$dumpfile("register32.t.vcd");
	    $dumpvars(0, testregister32);
	    
	    $display("32 bit Register test bench");
        $display("--------------------------");

	    dutpassed = 1;

	    // Test Case 1:
	    //    LW
	    instruction = {6'd35, 6'd8, 6'd11, 15'd12};
	    #5;
	    if(rs != 6'd8) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rs != 6'd11) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW rt is not correct");
            $display("	rt reads %d when should be 11", rt);
	    end
	    if(imm16 != 15'd12) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW imm16 is not correct");
            $display("	imm16 reads %d when should be 12", imm16);
	    end
	    if(RegDst != 0) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW RegDst is not correct");
            $display("	RegDst reads %d when should be 0 for LW", RegDst);
	    end
	    if(RegWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW RegWr is not correct");
            $display("	RegWr reads %d when should be 1 for LW", RegWr);
	    end
	    if(AlUSrc != 0) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 0 for LW", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for LW", MemWr);
	    end
	    if(MemToReg != 1) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW MemToReg is not correct");
            $display("	MemToReg reads %d when should be 1 for LW", AlUSrc);
	    end
	    if(ALUcntrl != 4'd00) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 0000 for ADD for LW", AlUSrc);
	    end

	    // Test Case 2:
	    //    SW
	    instruction = {6'd43, 6'd8, 6'd11, 15'd12};
	    #5;
	    if(rs != 6'd8) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rs != 6'd11) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW rt is not correct");
            $display("	rt reads %d when should be 11", rt);
	    end
	    if(imm16 != 15'd12) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW imm16 is not correct");
            $display("	imm16 reads %d when should be 12", imm16);
	    end
	    // if(RegDst != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 2 Failed - LW RegDst is not correct");
     //        $display("RegDst reads %d when should be 0 for LW", RegDst);
	    // end
	    if(RegWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW RegWr is not correct");
            $display("	RegWr reads %d when should be 0 for SW", RegWr);
	    end
	    if(AlUSrc != 0) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 0 for SW", AlUSrc);
	    end
	    if(MemWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW MemWr is not correct");
            $display("	MemWr reads %d when should be 1 for SW", MemWr);
	    end
	    if(MemToReg != 1) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW MemToReg is not correct");
            $display("	MemToReg reads %d when should be 1 for SW", AlUSrc);
	    end
	    if(ALUcntrl != 4'd00) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 0000 for ADD for SW", AlUSrc);
	    end

	    // Test Case 3:
	    //    BNE
	    instruction = {6'd05, 6'd8, 6'd11, 15'd12};
	    #5;
	    if(rs != 6'd8) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rs != 6'd11) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE rt is not correct");
            $display("	rt reads %d when should be 11", rt);
	    end
	    if(imm16 != 15'd12) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE imm16 is not correct");
            $display("	imm16 reads %d when should be 12", imm16);
	    end
	    // if(RegDst != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 2 Failed - LW RegDst is not correct");
     //        $display("RegDst reads %d when should be 0 for LW", RegDst);
	    // end
	    if(RegWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE RegWr is not correct");
            $display("	RegWr reads %d when should be 0 for BNE", RegWr);
	    end
	    if(AlUSrc != 1) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 1 for BNE", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for SW", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for BNE", AlUSrc);
	    end
	    if(ALUcntrl != 4'd06) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 6 for SUB for BNE", AlUSrc);
	    end
	    if(branch != 1) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE branch is not correct");
            $display("	branch reads %d when should be 1 for BNE", branch);
	    end

	    // Test Case 4:
	    //    XORI
	    instruction = {6'd14, 6'd8, 6'd11, 15'd12};
	    #5;
	    if(rs != 6'd8) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rs != 6'd11) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE rt is not correct");
            $display("	rt reads %d when should be 11", rt);
	    end
	    if(imm16 != 15'd12) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE imm16 is not correct");
            $display("	imm16 reads %d when should be 12", imm16);
	    end
	    // if(RegDst != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 2 Failed - LW RegDst is not correct");
     //        $display("RegDst reads %d when should be 0 for LW", RegDst);
	    // end
	    if(RegWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE RegWr is not correct");
            $display("	RegWr reads %d when should be 0 for BNE", RegWr);
	    end
	    if(AlUSrc != 1) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 1 for BNE", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for SW", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for BNE", AlUSrc);
	    end
	    if(ALUcntrl != 4'd06) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 6 for SUB for BNE", AlUSrc);
	    end

	    if(dutpassed == 0) begin
        	$display("32 bit Register is broken!!");
    	end else begin
        	$display("32 bit Register works!!");
    	end  

    	$finish; 
    end

endmodule
