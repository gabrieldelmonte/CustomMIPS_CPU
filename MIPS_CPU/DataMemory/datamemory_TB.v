`timescale 1ns / 1ps

module datamemory_TB();

	// Signal declarations for inputs and outputs
	reg [9:0] address;       // 10-bit read address (can access 1024 words)
	reg clock;               // System clock
	reg [31:0] data;         // Input data (not used during read)
	reg wren;                // Write enable (0 = read-only)
	wire [31:0] q;           // Output data from memory

	// Instantiate the memory module
	datamemory uut (
		.address(address),
		.clock(clock),
		.data(data),
		.wren(wren),
		.q(q)
	);

	// Clock generation: 100 MHz (10 ns period, toggles every 5 ns)
	initial clock = 0;
	always #5 clock = ~clock;

	// Test procedure
	initial begin
		$display("=== Data Memory Testbench Start ===");

		// Initialize signals
		address = 10'd0;
		data = 32'd0;
		wren = 0;

		// Wait a few initial clock cycles
		#20;

		// Read and display the first 32 memory locations (address 0 to 31)
		for (address = 0; address < 32; address = address + 1) begin
			#10; // Wait for a clock edge
			$display("Address: %2d | Data Read: %h", address, q);
		end

		$display("=== Data Memory Testbench End ===");
		$stop;
	end

endmodule
