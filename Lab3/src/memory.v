module memory(clk, regWE, Addr, DataIn, DataOut);
  	input clk, regWE;
  	input[31:0] Addr;
  	input[31:0] DataIn;
  	output[31:0]  DataOut;

	reg [31:0] mem[1023:0];  
	always @(posedge clk)
  		if (regWE)
    		mem[Addr] <= DataIn;
	initial $readmemh("data.dat", mem);

	assign DataOut = mem[Addr];
endmodule