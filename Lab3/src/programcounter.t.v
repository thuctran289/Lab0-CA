module  testprogramCounter();
    reg clk;
    reg [31:0] d;
    wire [31:0] q;
    reg addr_we;

    programCounter DUT(clk, d, addr_we, q);


    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    initial d = 0;
    initial addr_we = 0;
    
initial begin
    $dumpfile("testprogramcounter.t.vcd");
    $dumpvars(0,testprogramCounter);
    d = 1;
    #10
    addr_we = 1;
    #10
    d = 10;
    #10
    addr_we = 0;
    d = 100;
    #10
    $finish;
end


endmodule

