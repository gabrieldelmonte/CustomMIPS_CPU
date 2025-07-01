`timescale 1ns/1ps

module register_TB();

	// Input signals
	reg [31:0] input_data;
	reg clock;
	reg reset;

	// Output signal
	wire [31:0] output_data;

	// Instantiate the register module
	register uut (
		.input_data(input_data),
		.clock(clock),
		.reset(reset),
		.output_data(output_data)
	);

	// Clock generation: 50 MHz (20 ns period)
	initial begin
		clock = 0;
		forever #10 clock = ~clock;
	end

	// Stimulus process
	initial begin
		// Initialize signals
		input_data = 32'h00000000;
		reset = 1;

		// Monitor signal changes
		$monitor("Time: %0t | reset: %b | input_data: %h | output_data: %h", $time, reset, input_data, output_data);

		// Apply reset
		#5;  reset = 1;
		#15; reset = 0;

		// Test 1: Load value into register
		input_data = 32'hAABBCCDD;
		#20; // Wait for next rising edge

		// Test 2: Load another value
		input_data = 32'hFFEEDDCC;
		#20;

		// Test 3: Apply reset again
		reset = 1;
		#10;
		reset = 0;

		// Test 4: Load a new value after reset
		input_data = 32'h12345678;
		#20;

		// Final step
		$stop;
	end

endmodule
