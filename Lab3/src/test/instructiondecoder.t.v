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
		$dumpfile("instructiondecoder.t.vcd");
	    $dumpvars(0, testinstructiondecoder);
	    
	    $display("32 bit Register test bench");
        $display("--------------------------");

	    dutpassed = 1;

	    // Test Case 1:
	    //    LW
	    instruction = {6'd35, 5'd8, 5'd11, 16'd12};
	    #5;
	    if(rs != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW rs is not correct");
            $display("	rs reads %b when should be 8", rs);
	    end
	    if(rt != 5'd11) begin
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
            $display("	MemToReg reads %d when should be 1 for LW", MemToReg);
	    end
	    if(ALUcntrl != 4'd02) begin
	    	dutpassed = 0;
            $display("Test Case 1 Failed - LW ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 2 for ADD for LW", ALUcntrl);
	    end

	    // Test Case 2:
	    //    SW
	    instruction = {6'd43, 5'd8, 5'd11, 16'd12};
	    #5;
	    if(rs != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rt != 5'd11) begin
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
            $display("	MemToReg reads %d when should be 1 for SW", MemToReg);
	    end
	    if(ALUcntrl != 4'd2) begin
	    	dutpassed = 0;
            $display("Test Case 2 Failed - SW ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 2 for ADD for SW", ALUcntrl);
	    end

	    // Test Case 3:
	    //    BNE
	    instruction = {6'd05, 5'd8, 5'd11, 16'd12};
	    #5;
	    if(rs != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rt != 5'd11) begin
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
            $display("	MemWr reads %d when should be 0 for BNE", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for BNE", MemToReg);
	    end
	    if(ALUcntrl != 4'd06) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 6 for SUB for BNE", ALUcntrl);
	    end
	    if(branch != 1) begin
	    	dutpassed = 0;
            $display("Test Case 3 Failed - BNE branch is not correct");
            $display("	branch reads %d when should be 1 for BNE", branch);
	    end

	    // Test Case 4:
	    //    XORI
	    instruction = {6'd14, 5'd8, 5'd11, 16'd12};
	    #5;
	    if(rs != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI rs is not correct");
            $display("	rs reads %d when should be 8", rs);
	    end
	    if(rt != 5'd11) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI rt is not correct");
            $display("	rt reads %d when should be 11", rt);
	    end
	    if(imm16 != 15'd12) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI imm16 is not correct");
            $display("	imm16 reads %d when should be 12", imm16);
	    end
	    if(RegDst != 0) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI RegDst is not correct");
            $display("	RegDst reads %d when should be 0 for XORI", RegDst);
	    end
	    if(RegWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI RegWr is not correct");
            $display("	RegWr reads %d when should be 1 for XORI", RegWr);
	    end
	    if(AlUSrc != 0) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 0 for XORI", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for XORI", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - XORI MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for XORI", MemToReg);
	    end
	    if(ALUcntrl != 4'd10) begin
	    	dutpassed = 0;
            $display("Test Case 4 Failed - BNE ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 10 for XOR for XORI", ALUcntrl);
	    end

	    // Test Case 5:
	    //    J
	    instruction = {6'd2, 26'd30};
	    #5;
	    // if(RegDst != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 5 Failed - J RegDst is not correct");
     //        $display("	RegDst reads %d when should be 0 for XORI", RegDst);
	    // end
	    // if(RegWr != 1) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI RegWr is not correct");
     //        $display("	RegWr reads %d when should be 1 for XORI", RegWr);
	    // end
	    // if(AlUSrc != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI ALUSrc is not correct");
     //        $display("	AlUSrc reads %d when should be 0 for XORI", AlUSrc);
	    // end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 5 Failed - J MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for J", MemWr);
	    end
	    // if(MemToReg != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI MemToReg is not correct");
     //        $display("	MemToReg reads %d when should be 0 for XORI", MemToReg);
	    // end
	    // if(ALUcntrl != 4'd10) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - BNE ALUcntrl is not correct");
     //        $display("	ALUcntrl reads %d when should be 10 for XOR for XORI", ALUcntrl);
	    // end
	    if(jump != 1) begin
	    	dutpassed = 0;
            $display("Test Case 5 Failed - jump flag is not set for J");
            $display("	jump reads %d when should be 1 for J", jump);
	    end

	    // Test Case 6:
	    //    JAL
	    instruction = {6'd3, 26'd30};
	    #5;
	    if(rt != 5'd31) begin
	    	dutpassed = 0;
            $display("Test Case 6 Failed - JAL rt is not correct");
            $display("	rt reads %d when should be 31", rt);
	    end
	    if(RegDst != 0) begin
	    	dutpassed = 0;
            $display("Test Case 6 Failed - JAL RegDst is not correct");
            $display("	RegDst reads %d when should be 0 for JAL", RegDst);
	    end
	    if(RegWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 6 Failed - JAL RegWr is not correct");
            $display("	RegWr reads %d when should be 1 for JAL", RegWr);
	    end
	    // if(AlUSrc != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI ALUSrc is not correct");
     //        $display("	AlUSrc reads %d when should be 0 for XORI", AlUSrc);
	    // end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 6 Failed - JAL MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for JAL", MemWr);
	    end
	    // if(MemToReg != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI MemToReg is not correct");
     //        $display("	MemToReg reads %d when should be 0 for XORI", MemToReg);
	    // end
	    // if(ALUcntrl != 4'd10) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - BNE ALUcntrl is not correct");
     //        $display("	ALUcntrl reads %d when should be 10 for XOR for XORI", ALUcntrl);
	    // end
	    if(jump != 1) begin
	    	dutpassed = 0;
            $display("Test Case 6 Failed - jump flag is not set for JAL");
            $display("	jump reads %d when should be 1 for JAL", jump);
	    end
	    if(jal != 1) begin
	    	dutpassed = 0;
            $display("Test Case 5 Failed - jal flag is not set for JAL");
            $display("	jal reads %d when should be 1 for JAL", jal);
	    end

	    // Test Case 7:
	    //    JR
	    instruction = {6'd0, 5'd31, 5'd19, 5'd8, 5'd0, 5'd08};
	    #5;
	    if(rs != 5'd31) begin
	    	dutpassed = 0;
            $display("Test Case 7 Failed - JR rs is not correct");
            $display("	rs reads %d when should be 31", rs);
	    end
	    // if(RegDst != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI RegDst is not correct");
     //        $display("	RegDst reads %d when should be 0 for XORI", RegDst);
	    // end
	    // if(RegWr != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI RegWr is not correct");
     //        $display("	RegWr reads %d when should be 1 for XORI", RegWr);
	    // end
	    // if(AlUSrc != 0) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - XORI ALUSrc is not correct");
     //        $display("	AlUSrc reads %d when should be 0 for XORI", AlUSrc);
	    // end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 7 Failed - JR MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for JR", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 7 Failed - JR MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for JR", MemToReg);
	    end
	    // if(ALUcntrl != 4'd10) begin
	    // 	dutpassed = 0;
     //        $display("Test Case 4 Failed - BNE ALUcntrl is not correct");
     //        $display("	ALUcntrl reads %d when should be 10 for XOR for XORI", ALUcntrl);
	    // end
	    if(jump != 1) begin
	    	dutpassed = 0;
            $display("Test Case 7 Failed - jump flag is not set for JR");
            $display("	jump reads %d when should be 1 for JR", jump);
	    end
	    if(jr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 7 Failed - jr flag is not set for JR");
            $display("	jr reads %d when should be 1 for JR", jr);
	    end

	    // Test Case 8:
	    //    ADD
	    instruction = {6'd0, 5'd9, 5'd10, 5'd8, 5'd0, 6'd32};
	    #5;
	    if(rs != 5'd9) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD rs is not correct");
            $display("	rs reads %d when should be 9", rs);
	    end
	    if(rt != 5'd10) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD rt is not correct");
            $display("	rt reads %d when should be 10", rt);
	    end
	    if(rd != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD rd is not correct");
            $display("	rd reads %d when should be 8", rd);
	    end
	    if(RegDst != 1) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD RegDst is not correct");
            $display("	RegDst reads %d when should be 1 for ADD", RegDst);
	    end
	    if(RegWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD RegWr is not correct");
            $display("	RegWr reads %d when should be 1 for ADD", RegWr);
	    end
	    if(AlUSrc != 1) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 1 for ADD", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for ADD", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for ADD", MemToReg);
	    end
	    if(ALUcntrl != 4'd02) begin
	    	dutpassed = 0;
            $display("Test Case 8 Failed - ADD ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 2 for ADD for ADD", ALUcntrl);
	    end

	    // Test Case 9:
	    //    SUB
	    instruction = {6'd0, 5'd9, 5'd10, 5'd8, 5'd0, 6'd34};
	    #5;
	    if(rs != 5'd9) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB rs is not correct");
            $display("	rs reads %d when should be 9", rs);
	    end
	    if(rt != 5'd10) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB rt is not correct");
            $display("	rt reads %d when should be 10", rt);
	    end
	    if(rd != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB rd is not correct");
            $display("	rd reads %d when should be 8", rd);
	    end
	    if(RegDst != 1) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB RegDst is not correct");
            $display("	RegDst reads %d when should be 1 for SUB", RegDst);
	    end
	    if(RegWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB RegWr is not correct");
            $display("	RegWr reads %d when should be 1 for SUB", RegWr);
	    end
	    if(AlUSrc != 1) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 1 for SUB", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for SUB", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for SUB", MemToReg);
	    end
	    if(ALUcntrl != 4'd06) begin
	    	dutpassed = 0;
            $display("Test Case 9 Failed - SUB ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 6 for SUB for SUB", ALUcntrl);
	    end

	    // Test Case 10:
	    //    SLT
	    instruction = {6'd0, 5'd9, 5'd10, 5'd8, 5'd0, 6'd42};
	    #5;
	    if(rs != 5'd9) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT rs is not correct");
            $display("	rs reads %d when should be 9", rs);
	    end
	    if(rt != 5'd10) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT rt is not correct");
            $display("	rt reads %d when should be 10", rt);
	    end
	    if(rd != 5'd8) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT rd is not correct");
            $display("	rd reads %d when should be 8", rd);
	    end
	    if(RegDst != 1) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT RegDst is not correct");
            $display("	RegDst reads %d when should be 1 for SLT", RegDst);
	    end
	    if(RegWr != 1) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT RegWr is not correct");
            $display("	RegWr reads %d when should be 1 for SLT", RegWr);
	    end
	    if(AlUSrc != 1) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT ALUSrc is not correct");
            $display("	AlUSrc reads %d when should be 1 for SLT", AlUSrc);
	    end
	    if(MemWr != 0) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT MemWr is not correct");
            $display("	MemWr reads %d when should be 0 for SLT", MemWr);
	    end
	    if(MemToReg != 0) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT MemToReg is not correct");
            $display("	MemToReg reads %d when should be 0 for SLT", MemToReg);
	    end
	    if(ALUcntrl != 4'd07) begin
	    	dutpassed = 0;
            $display("Test Case 10 Failed - SLT ALUcntrl is not correct");
            $display("	ALUcntrl reads %d when should be 7 for SLT for SLT", ALUcntrl);
	    end

	    if(dutpassed == 0) begin
        	$display("Instruction decoder is broken!!");
    	end else begin
        	$display("Instruction decoder works!!");
    	end 

    	instruction = 32'h014b4820;
    	$display(dut.opcode);
    	#500

    	$finish; 
    end

endmodule
