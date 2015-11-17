module concatenate(
input [3:0] PC,
input [25:0] Tinst,
output [29:0] new_inst
);

assign new_inst = {PC, Tinst};


endmodule
