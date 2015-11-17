module testFullAdder30();
reg [29:0] a;
reg [29:0] b;
wire [29:0] result;

FullAdder30 DUT(result, a, b, 1);

initial begin
	

        $dumpfile("testFullAdder30.t.vcd");
        $dumpvars(0, testFullAdder30);
        a = 1;
        b = 1;
        #10;



end





endmodule