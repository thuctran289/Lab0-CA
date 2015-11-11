module testspimemory();
        reg clk;
        reg sclk_pin;
        reg cs_pin;
        wire miso_pin;
        reg mosi_pin;
        reg fault_pin;
        wire [3:0] leds;

        spiMemory dut(.clk(clk),
                                        .sclk_pin(sclk_pin),
                                        .cs_pin(cs_pin),
                                        .miso_pin(miso_pin),
                                        .mosi_pin(mosi_pin),
                                        .fault_pin(fault_pin),
                                        .leds(leds));
        integer i,j; 
        initial clk=0;
        initial sclk_pin=1;
        always #10 clk=!clk;
        always #10 sclk_pin=!sclk_pin;
        initial fault_pin = 0;
        initial cs_pin = 1;

        always @(dut.fsm.state) begin
            $display("STATE: %b", dut.fsm.state);
        end

        always @(dut.sr.parallelDataOut) begin
            $display("parallelOut: %b", dut.sr.parallelDataOut);
        end

        initial begin
            $dumpfile("spimemory.t.vcd");
            $dumpvars(0, testspimemory);
            $write("%c[35m",27);
        	$display("SPI memory test bench");
        	$display("---------------------");
        	$write("%c[0m",27);
		
//         	cs_pin = 1;

//             i = 0;
//            j = 0;
//            for (i=0; i<128; i = i+1) begin
               
//                for (j=0; j<7; j = j+1) begin
//                    #1000
//                    mosi_pin = i[j];
                   
//                end
//                mosi_pin = 1;

//                #3200
//                cs_pin = 1;
//                #400
//                cs_pin = 0;
//                mosi_pin = 0;

//            end
//            $finish;
//        end


// endmodule 

        	i = 7'b1011001; //address
			//for (i=0; i<128; i = i+1) begin
				cs_pin = 0;
                // WRITE
				for (j=0; j<7; j = j+1) begin
					mosi_pin = i[j]; #20;
				end

                // $display("%b", dut.shiftRegOutP);

				mosi_pin = 0; #20; // SET TO WRITE
				mosi_pin = 1; #140; // DATA TO WRITE 8'b1111 1111

                cs_pin = 1; #20; // RESET CONTROLS
                cs_pin = 0; // PREPARE TO READ

                // READ
                for (j=0; j<7; j = j+1) begin // SEND IN ADDRESS
                    mosi_pin = i[j]; #20;
                end

                mosi_pin = 1; #20; // SET TO READ
                #160
			//end

			$finish;
		end
endmodule

