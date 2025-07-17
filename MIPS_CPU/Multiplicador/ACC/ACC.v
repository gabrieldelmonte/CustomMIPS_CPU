module ACC (
	input [32:0] Entradas,
	input Ad,
	input Clk,
	input Load, 
	input Sh, 
	output reg [32:0] Saidas
);

	always @(posedge Clk) begin
		if (Ad) 
			Saidas <= {Entradas[32:16], Saidas[15:0]};
		else if (Load) 
			Saidas <= {17'b0, Entradas[15:0]};
		else if (Sh) 
			Saidas <= {1'b0, Saidas[32:1]};
		else  
			Saidas <= Saidas;
	end

endmodule
