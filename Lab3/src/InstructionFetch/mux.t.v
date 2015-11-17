module testmux();

reg [15:0] a;
reg [15:0] b;

reg choice;
wire [15:0] out;

mux16by2to1 DUT(out, choice, a, b);

initial begin

        $dumpfile("testmux.t.vcd");
        $dumpvars(0, testmux);
		a = 0;
		b = -1;
		choice = 0;
		#10;
		choice = 1;
		#10;



end


endmodule