module tristatebuffer
(
	input MISO_BUFF,
	input q,
	output miso_pin
);
	assign miso_pin = MISO_BUFF?q: 'bz;

endmodule