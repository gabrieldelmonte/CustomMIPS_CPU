module ACC (
	input Load, Sh, Ad, Clk, 
	input [8:0] Entradas,
	output [8:0] Saidas
);

	reg [8:0]acc_reg = 9'b0;

	always @(posedge Clk) begin
		if (Load & ~Ad & ~Sh)
			acc_reg <= {5'b0, Entradas[3:0]};
		else if (~Load & Ad & ~Sh)
			acc_reg <= {Entradas[8:4], acc_reg[3:0]};
		else if (~Load & ~Ad & Sh)
			acc_reg <= {1'b0, acc_reg[8:1]};
	end

	assign Saidas = acc_reg;

endmodule
