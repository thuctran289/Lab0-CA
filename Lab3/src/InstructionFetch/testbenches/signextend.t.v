module testsignextend();
reg [15:0] imm16;
wire[29:0] imm32;

signextend DUT(imm16, imm32);


initial begin
	

        $dumpfile("signextend.t.vcd");
        $dumpvars(0, testsignextend);
        imm16 = 0;
        #10;
        imm16 = -1;
        #10;
        imm16 = 1000;
        #10;
        imm16 = -1000;
        #10;
end


endmodule