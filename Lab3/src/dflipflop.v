// D flip flop that holds serial output of the shift register

module dflipflop
(
	input clk,
	input d,
	input addr_we,
	output reg q
);

	always @(posedge clk) begin  //update on every clock edge
		if (addr_we)
			q<=d;
	end
endmodule
