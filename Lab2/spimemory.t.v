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
        initial sclk_pin=0;
        always #10 clk=!clk;
        always #230 sclk_pin=!sclk_pin;
        initial fault_pin = 0;
        initial cs_pin = 0;


        initial begin
                $dumpfile("spimemory.t.vcd");
                $dumpvars(0, testspimemory);
                $write("%c[35m",27);
        	$display("SPI memory test bench");
        	$display("---------------------");
        	$write("%c[0m",27);
		
        	// cs_pin = 1;
        	i = 0;
        	j = 0;
			for (i=0; i<128; i = i+1) begin
				
				for (j=0; j<7; j = j+1) begin
					#1000
					mosi_pin = i[j];
					
				end
				mosi_pin = 1;

				#3200
				cs_pin = 1;
				#400
				cs_pin = 0;
				mosi_pin = 0;

			end
			$finish;
		end


endmodule