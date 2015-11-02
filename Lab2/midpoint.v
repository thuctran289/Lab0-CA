module midpoint
(

    input        clk,
    input  [1:0] sw,
    input  [3:0] btn,
    output [3:0] led
    _);

	wire [2:0] conditioned;
	wire [2:0] positiveedge;
	wire [2:0] negativeedge;
	wire [7:0] ledout;
	wire serialout;
	inputconditioner button0(clk, btn[0], conditioned[0], positiveedge[0], negativeedge[0]);
	inputconditioner switch0(clk, sw[0], conditioned[1], positiveedge[1], negativeedge[1]);
	inputconditioner switch1(clk, sw[1], conditioned[2], positiveedge[2], negativeedge[2]);

	shiftregister d(clk, positiveedge[2], negativeedge[0], 8'hA5, conditioned[1], ledout, serialout );




endmodule 