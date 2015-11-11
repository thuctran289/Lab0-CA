//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin,  // For fault injection testing
    output [3:0]    leds        // LEDs for debugging
);
	wire serialout;
	
	wire [2:0] conditioned; 
	wire [2:0] positiveedge;  
	wire [2:0] negativeedge;  
	wire SR_WE, MISO_BUFF, DM_WE, ADDR_WE;
	wire [7:0] dout, shiftRegOutP, dataMemOut;
	wire shiftRegOutS;
	wire [7:0] address;
	wire q;
	
	inputconditioner MOSI(clk, mosi_pin, conditioned[0], positiveedge[0], negativeedge[0]);
	inputconditioner SCLK(clk, sclk_pin, conditioned[1], positiveedge[1], negativeedge[1]);
	inputconditioner CS(clk, cs_pin, conditioned[2], positiveedge[2], negativeedge[2]);

	shiftregister sr(clk, positiveedge[1], SR_WE, dataMemOut, conditioned[0], shiftRegOutP, shiftRegOutS);
	
	addresslatch al(clk, shiftRegOutP, ADDR_WE, address);
	
	finitestatemachine fsm(positiveedge[1], conditioned[2], shiftRegOutP[0], MISO_BUFF, DM_WE, ADDR_WE, SR_WE);

	dflipflop dff(clk, shiftRegOutS, negativeedge[1], q);

	tristatebuffer tsb(MISO_BUFF, q, miso_pin);

	datamemory dm(clk, dataMemOut, address[6:0], DM_WE, shiftRegOutP);
endmodule
