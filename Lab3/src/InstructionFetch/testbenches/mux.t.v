module testmux();

reg [15:0] a;
reg [15:0] b;

reg choice;
wire [15:0] out;

muxNby2to1 #(16) DUT(out, choice, a, b);
reg [29:0] a1,b1;
reg choice1;
wire [29:0] out1;

muxNby2to1 #(30) DUT1(out1, choice1,a1,b1);
initial begin

        $dumpfile("testmux.t.vcd");
        $dumpvars(0, testmux);
		a = 0;
		b = -1;
		choice = 0;
		#10;
		choice = 1;
		#10;
		a1 = 0;
		b1 = -1;
		choice1 = 0;
		#10;
		choice1 = 1;
		#10;


end


endmodule