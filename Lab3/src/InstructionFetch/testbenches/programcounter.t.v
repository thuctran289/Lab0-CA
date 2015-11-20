module  testprogramCounter();
    reg clk;
    reg [31:0] d;
    wire [31:0] q;
    reg addr_we;

    programcounter DUT(clk, d, addr_we, q);


    initial clk=0;
    always #1 clk=!clk;    // 50MHz Clock
    initial d = 0;
    initial addr_we = 0;
    
initial begin
    $dumpfile("testprogramcounter.t.vcd");
    $dumpvars(0,testprogramCounter);
    $display("Program Counter Testing");
    $display("AddreWE,   D,          Q");
    $display("%d,%d, %d", addr_we, d, q);
    d = 10;
    addr_we = 1;
    #2

    $display("%d,%d, %d", addr_we, d, q);
    d = 100;
    #2
    $display("%d,%d, %d", addr_we, d, q);
    addr_we = 0;
    d = 1000;

    $display("%d,%d, %d", addr_we, d, q);
    #2
    $finish;
end


endmodule

