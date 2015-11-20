module testsignextend();
reg [15:0] imm16;
wire[29:0] imm30;

signextend DUT(imm16, imm30);


initial begin
	

        $dumpfile("testsignextend.t.vcd");
        $dumpvars(0, testsignextend);
        $display("TESTING SIGN EXTEND");
        $display("IMM16 IMM30");

        imm16 = 10;
        $display("%b, %b",imm16, imm30);
        imm16 = -1;
        #10;

        $display("%b, %b",imm16, imm30);
        imm16 = 1000;
        #10;

        $display("%b, %b",imm16, imm30);
        imm16 = -1000;
        #10;

        $display("%b, %b",imm16, imm30);        
end


endmodule