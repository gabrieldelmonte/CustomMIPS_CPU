module Counter (
	input Load, Clk,
	output reg K
);

	reg [2:0]count;

	always @(posedge Clk) begin
		if (Load) begin
			count <= 3'b000;
			K <= 1'b0;
		end
		else if (count == 3'b110) begin
            count <= 3'b000;
			K <= 1'b1;
		end
		else begin
			count <= count + 1;
			K <= 1'b0;
		end
	end

endmodule
