module Counter (
	input Load, Clk, reset,
	output reg K
);

	reg [7:0]count;

	always @(posedge Clk, posedge reset) begin
		if (reset) begin
			count <= 8'b0;
			K <= 0;
		end
		else if (Load) begin
			count <= 8'b0;
			K <= 0;
		end
		else if (count == 29)
			K <= 1;
		else
			count <= (count + 1);
	end

endmodule
