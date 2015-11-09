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
	wire [7:0] dout, shiftRegOutP,dataMemOut;
	wire shiftRegOutS;
	wire [7:0] address;
	
	inputconditioner MOSI(clk, mosi_pin, conditioned[0], positiveedge[0], negativeedge[0]);
	inputconditioner SCLK(clk, sclk_pin, conditioned[1], positiveedge[1], negativeedge[1]);
	inputconditioner CS(clk, cs_pin, conditioned[2], positiveedge[2], negativeedge[2]);
	shiftregister sr(clk, positiveedge[1], SR_WE, dout, conditioned[0], shiftRegOutP, shiftRegOutS);
	addresslatch al(clk, shiftRegOutP, ADDR_WE, address);
	datamemory_breakable dm(clk, dataMemOut, address[7:1], DM_WE, shiftRegOutP, fault_pin);
endmodule


module addresslatch
//d latch module 
(
	input clk,
	input [7:0] d,
	input addr_we,
	output reg [7:0] q
);

	always @(clk==1)   //update on every clock edge
		if (addr_we==1)
			q=d;
endmodule

module finiteStateMachine(
	   input sclk,   //clock
	   input CS,     //reset signal
           input shiftOutS,  //shift register output
           output reg MISO_BUFF,  //Master-in slave-out
           output reg DM_WE,  //Data memory write-enable 
           output reg ADDR_WE,  //Write-enable for address latch
           output reg SR_WE  //Parallel load
);

	parameter SIZE = 3;  
	parameter GET = 3'b000, GOT = 3'b001, READ1 = 3'b010, READ2 = 3'b011, READ3 = 3'b100, WRITE1 = 3'b101, WRITE2 = 3'b110, DONE = 3'b111;
	//Binary encoding for phases
	reg [7:0] counter; //initiate counter

	reg [SIZE-1:0] state;  //Seq part of FSM
	reg [SIZE-1:0] next_state;  //Combo part for FSM

	always @ (posedge sclk) begin: FSM

	if (CS ==1 ) begin  //Reset counter when cs is 1
		state <= GET;
		assign counter = 0;

	end else
		case(state)
			GET: begin
				if (counter != 128) begin  //count 8 bits
					assign counter = counter << 1;
				end else begin
					state <= GOT; //move to next phase after getting the 8 bits
				end
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign ADDR_WE = 0;
				assign SR_WE = 0;
				end
			GOT: begin //read the LSB bit to determine whether to read or write
				if (shiftOutS == 1) // read
					state <= READ1; //move to READ1
				else // write
					state = WRITE1; //move to WRITE1
				assign counter = 0;
				assign ADDR_WE = 1;
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign SR_WE = 0;
				end
				
			READ1: begin //Data memory being read
				state <= READ2;
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign ADDR_WE = 0;
				assign SR_WE = 0;
				end
				
			READ2: begin  //Push the calue to shift register
				state <= READ3;
				assign SR_WE = 1;  //Enable parallel load
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign ADDR_WE = 0;
				end
				
			READ3: begin //Count the number of bits read
				if(counter != 128)
					assign counter = counter << 1;
				else
					state <= DONE;
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign ADDR_WE = 0;
				assign SR_WE = 0;
				end
				
			WRITE1: begin  //Count the number of bits stored
				if(counter!=128)
					assign counter = counter << 1;
				else
					state<=WRITE2;
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign ADDR_WE = 0;
				assign SR_WE = 0;
				end
				
			WRITE2: begin  //Write to data memory
				state <= DONE;
				assign DM_WE = 1; //Enable write enble for data memory
				assign MISO_BUFF = 0;
				assign ADDR_WE = 0;
				assign SR_WE = 0;
				end
				
			DONE: begin  //Done for one cycle
				assign counter = 0;
				assign MISO_BUFF = 0;
				assign DM_WE = 0;
				assign ADDR_WE = 0;
				assign SR_WE = 0;
				end
			default: state <= GET;  //reset FSM
	endcase
	end
endmodule

