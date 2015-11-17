module testconcatenate();
reg [3:0] PCbit;
reg [25:0] Tinst;
wire [29:0] out_inst;

concatenate DUT(PCbit, Tinst, out_inst);

initial begin
    $dumpfile("testconcatenate.t.vcd");
    $dumpvars(0,testconcatenate);
    PCbit = 5;
    Tinst = 151;
    #10
    PCbit = 10;
    #10
    Tinst = 200;
    #10
    $finish;
end



endmodule