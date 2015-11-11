// Finite state machine

module finitestatemachine(
	   	input sclk,   //clock
	   	input CS,     //reset signal
        input shiftOutP,  //shift register output
        output reg MISO_BUFF,  //Master-in slave-out
        output reg DM_WE,  //Data memory write-enable 
        output reg ADDR_WE,  //Write-enable for address latch
        output reg SR_WE  //Parallel load
);

	parameter 	SIZE = 3;  
	parameter	GET = 0,
				GOT = 1,
				READ1 = 2, 
				READ2 = 3,
				READ3 = 4,
				WRITE1 = 5,
				WRITE2 = 6,
				DONE = 7;
	//Binary encoding for phases
	reg [3:0] counter; //initiate counter
	// initial counter  = 0;
	reg [SIZE-1:0] state;

	always @(posedge sclk) begin

		if (CS) begin  //Reset counter when cs is 1
			state <= GET;
			counter <= 0;

		end else begin
			MISO_BUFF <= 0;
			DM_WE <= 0;
			ADDR_WE <= 0;
			SR_WE <= 0;

			case(state)
				GET: begin
					if (counter == 8) begin
						state <= GOT;
					end else begin
						counter <= counter + 1;
					end
					end
				GOT: begin //read the LSB bit to determine whether to read or write
					counter <= 0;
					ADDR_WE <= 1;
					if (shiftOutP) // read
						state <= READ1; //move to READ1
					else // write
						state <= WRITE1; //move to WRITE1
					end
					
				READ1: begin //Data memory being read
					state <= READ2;
					end
					
				READ2: begin  //Push the calue to shift register
					SR_WE <= 1;  //Enable parallel load
					state <= READ3;
					end
					
				READ3: begin //Count the number of bits read
					MISO_BUFF <= 1;
					if (counter == 8) begin
						state <= DONE;
					end else begin
						counter <= counter + 1;
					end
					end
					
				WRITE1: begin  //Count the number of bits stored
					if (counter == 8) begin
						state <= WRITE2;
					end else begin
						counter <= counter + 1;
					end
					end
					
				WRITE2: begin  //Write to data memory
					DM_WE <= 1; //Enable write enble for data memory
					state <= DONE;
					end
					
				DONE: begin  //Done for one cycle
					counter <= 0;
					end
		endcase
		end
	end
endmodule
