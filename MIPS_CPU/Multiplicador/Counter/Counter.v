module Counter (
	input Load, Clk,
	output reg K
);

	reg [5:0]count;

	always @(posedge Clk) begin
		if (Load) begin
			count <= 6'b000000;
			K <= 1'b0;
		end
		else if (count == 6'd30) begin
            count <= 6'b000000;
			K <= 1'b1;
		end
		else begin
			count <= count + 1;
			K <= 1'b0;
		end
	end

endmodule
