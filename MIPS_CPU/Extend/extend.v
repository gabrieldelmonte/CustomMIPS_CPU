module extend(
	input [15:0]input_data,
	output reg [31:0]output_data
);

	always @(*) begin
		if (input_data[15])
			output_data <= {16'hFFFF, input_data[15:0]};
		else
			output_data <= {16'h0000, input_data[15:0]};
	end

endmodule
