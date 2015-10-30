//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));

    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial peripheralClkEdge=0;
    always #20 peripheralClkEdge=!peripheralClkEdge;    // 25MHz Clock
    
    initial serialDataIn = 0;

    initial begin

    $dumpfile("shiftregister.t.vcd");
    $dumpvars(0, testshiftregister);
    $display("hello world");
    
    parallelDataIn = 255;
    serialDataIn = 0;
    #20
    #10
    parallelLoad = 1;
    #40;
    parallelLoad = 0;
    #200
    serialDataIn = 1;
    #100
    serialDataIn = 0;
    #500 $finish ;
    
    end

endmodule

