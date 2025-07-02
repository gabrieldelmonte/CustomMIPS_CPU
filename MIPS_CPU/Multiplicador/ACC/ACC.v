module ACC (
	input Load, Sh, Ad, Clk, 
	input [32:0] Entradas,
	output [32:0] Saidas
);

	reg [32:0]acc_reg = 33'b0;

	always @(posedge Clk) begin
		if (Load & ~Ad & ~Sh)
			acc_reg <= {17'b0, Entradas[15:0]};
		else if (~Load & Ad & ~Sh)
			acc_reg <= {Entradas[32:16], acc_reg[15:0]};
		else if (~Load & ~Ad & Sh)
			acc_reg <= {1'b0, acc_reg[32:1]};
	end

	assign Saidas = acc_reg;

endmodule
