module testFullAdder30();
reg [29:0] a;
reg [29:0] b;
wire [29:0] result;

FullAdder30 DUT(result, a, b, 1);

initial begin
	

        $dumpfile("testFullAdder30.t.vcd");
        $dumpvars(0, testFullAdder30);
        $display("TESTING FULL ADDER 30 BIT");
        $display("         A          B C      RESULT");
        a = 1;
        b = 1;
        #10;

        $display("%d,%d,1, %d", a,b,result);

        a = -1;
        b = 0;
        #10;

        $display("%d,%d,1, %d", a,b,result);
        a = -1;
        b = -1;
        #10;

        $display("%d,%d,1, %d", a,b,result);
        a = 1000;
        b = 1500;
        #10;

        $display("%d,%d,1, %d", a,b,result);

end





endmodule