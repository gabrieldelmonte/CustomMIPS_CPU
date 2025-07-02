module alu(
	input [31:0]input_data_A,
	input [31:0]input_data_B,
	input [1:0]selector,
	output reg [31:0]output_data,
	output zeroFlag
);

	assign zeroFlag = (output_data == 32'h0) ? 1 : 0;

	always @(*) begin
		case (selector)
			2'b00: output_data <= input_data_A + input_data_B;
			2'b01: output_data <= input_data_A - input_data_B;
			2'b10: output_data <= input_data_A & input_data_B;
			2'b11: output_data <= input_data_A | input_data_B;
		endcase
	end

endmodule
