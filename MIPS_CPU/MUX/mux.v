module mux(
	input selector,
	input [31:0]a,
	input [31:0]b,
	output [31:0]out
);

	assign out = (selector) ? b : a;

endmodule
