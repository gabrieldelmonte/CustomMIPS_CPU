module register #(parameter DATA_WIDTH = 32)(
	input [(DATA_WIDTH - 1):0]input_data,
	input clock,
	input reset,
	output reg [(DATA_WIDTH - 1):0]output_data
);

	always @(posedge clock, posedge reset) begin
		if (reset)
			output_data <= 0;
		else
			output_data <= input_data;	
	end

endmodule
