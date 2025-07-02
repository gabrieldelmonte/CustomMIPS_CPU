module registerfile(
	input clock,
	input we,
	input reset,
	input [4:0]rd,
	input [4:0]rs,
	input [4:0]rt,
	input [31:0]input_data,
	output reg [31:0]output_data_A,
	output reg [31:0]output_data_B
);

	reg [31:0]register[31:0];
	integer index;

	initial begin
		for (index = 0; index < 32; index = index + 1)
			register[index] <= 32'h0;
	end

	always @(posedge clock, posedge reset) begin
		if (reset) begin
			output_data_A <= 32'h0;
			output_data_B <= 32'h0;
		end
		else begin
			if (rs)
				output_data_A <= register[rs];
			else
				output_data_A <= 32'h0;

			if (rt)
				output_data_B <= register[rt];
			else
				output_data_B <= 32'h0;

			if (we && rd)
				register[rd] <= input_data;
		end
	end

endmodule
