`timescale 1ns/1ps

module extend_TB();
	reg [15:0] in;
	wire [31:0] out;

	// Instantiate the extend module
	extend uut (
		.input_data(in),
		.output_data(out)
	);

	initial begin
		// Test a positive value (no sign extension)
		in = 16'h0001; // Positive number
		#10;
		$display("Input: %h | Expected Output: 0000_0001 | Actual Output: %h", in, out);

		// Test another positive value
		in = 16'h1234;
		#10;
		$display("Input: %h | Expected Output: 0000_1234 | Actual Output: %h", in, out);

		// Test a negative value (-1)
		in = 16'hFFFF;
		#10;
		$display("Input: %h | Expected Output: FFFF_FFFF | Actual Output: %h", in, out);

		// Test another negative value
		in = 16'h8000;
		#10;
		$display("Input: %h | Expected Output: FFFF_8000 | Actual Output: %h", in, out);

		// Test zero
		in = 16'h0000;
		#10;
		$display("Input: %h | Expected Output: 0000_0000 | Actual Output: %h", in, out);

		// Finish simulation
		$stop;
	end

endmodule
