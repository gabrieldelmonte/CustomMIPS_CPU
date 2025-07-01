module register(
	input [31:0]input_data,
	input clock,
	input reset,
	output reg [31:0]output_data
);

	always @(posedge clock, posedge reset) begin
		if (reset)
			output_data <= 0;
		else
			output_data <= input_data;	
	end

endmodule
