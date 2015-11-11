module addresslatch
//d latch module 
(
	input clk,
	input [7:0] d,
	input addr_we,
	output reg [7:0] q
);

	always @(posedge clk) begin   //update on every clock edge
		if (addr_we)
			q<=d;
	end
endmodule