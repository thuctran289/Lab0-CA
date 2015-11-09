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

    initial begin
        $dumpfile("shiftregister.t.vcd");
        $dumpvars(0, testshiftregister);
        $write("%c[35m",27);
        $display("Shift register test bench");
        $display("-------------------------");
        $write("%c[0m",27);
        $display("Test I Parallel in, serial out.");
        $display("parallelLoad | parallelDataIn | serialDataOut | Expected Out");
        parallelLoad = 1; parallelDataIn = 8'b10011010; #20  
        $display("%b            | %b       | %b             | 1", parallelLoad, parallelDataIn, serialDataOut);
        $display("-----------------------------------------------");
        parallelLoad = 0;
        $display("Test II Serial in, parallel out.");
        $display("peripheralClkEdge | serialDataIn | parallelDataOut | Expected Out");
        peripheralClkEdge = 1; serialDataIn = 1; #20
        $display("%b                 | %b            | %b        | 00110101", peripheralClkEdge, serialDataIn, parallelDataOut);
        $display("-----------------------------------------------");
        $finish;
    end
  

endmodule
