`timescale 1ns / 1ps

module InstMem_TB();

	// Input signals
	reg [9:0] address;
	reg clock;

	// Output signal
	wire [31:0] q;

	// Instantiate the Unit Under Test (UUT)
	InstMem uut (
		.address(address),
		.clock(clock),
		.q(q)
	);

	// Clock generation: 50 MHz (period = 20 ns)
	initial begin
		clock = 0;
		forever #10 clock = ~clock;
	end

	// Stimulus for the module
	initial begin
		// Initialize address
		address = 10'd0;
		$display("Starting instruction memory simulation...");

		// Monitor output values
		$monitor("Time: %0t | Address: %0d | Data (q): %h", $time, address, q);

		// Wait some cycles before starting
		#30;

		// Read 32 addresses from memory (in steps of 4)
		repeat (32) begin
			#20; // wait 1 clock cycle
			address = address + 10'd4;
		end

		// End of simulation
		#50;
		$display("Simulation finished.");
		$stop;
	end

endmodule
