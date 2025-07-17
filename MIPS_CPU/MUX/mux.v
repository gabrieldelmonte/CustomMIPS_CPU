module mux(
	input wire [31:0]a,
	input wire [31:0]b,
	input wire selector,
	output wire [31:0]out
);

	assign out = (selector) ? b : a;

endmodule
