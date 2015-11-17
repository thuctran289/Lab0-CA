

module  programcounter(
	input clk,
	input [31:0] d,
	input addr_we,
	output reg [31:0] q
);//This module is the address of the nnext instruction to be used in the program
//Essentially a 4 byte long address. 
initial q= 0;
	always @(posedge clk) begin   //update on every clock edge
		if (addr_we)
			q<=d;
	end



endmodule

