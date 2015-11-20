module testconcatenate();
reg [3:0] PCbit;
reg [25:0] Tinst;
wire [29:0] out_inst;

concatenate DUT(PCbit, Tinst, out_inst);

initial begin
    $dumpfile("testconcatenate.t.vcd");
    $dumpvars(0,testconcatenate);
    $display("Leading Bits,               Second Bits,                        Results");
    PCbit = -1;
    Tinst = 0;
    $display("        %b,%b, %b", PCbit, Tinst, out_inst);
    Tinst = -1;

    $display("        %b,%b, %b", PCbit, Tinst, out_inst);
    PCbit = 0;

    $display("        %b,%b, %b", PCbit, Tinst, out_inst);
    Tinst = 155;

    $display("        %b,%b, %b", PCbit, Tinst, out_inst);
    PCbit = 5;
    
    $display("        %b,%b, %b", PCbit, Tinst, out_inst);
    $finish;
end



endmodule