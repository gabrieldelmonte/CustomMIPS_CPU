`timescale 1ns/1ps

module registerfile_TB();

	// Testbench signals
	reg Clk;
	reg we;                  // Write enable
	reg [4:0] rs, rt, rd;    // Source registers and destination register
	reg [31:0] in;           // Data to write
	wire [31:0] outA, outB;  // Data outputs

	// Instantiate the register file module
	registerfile uut (
		.clock(Clk),
		.we(we),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.input_data(in),
		.output_data_A(outA),
		.output_data_B(outB)
	);

	// Generate a 10 ns clock (100 MHz)
	initial begin
		Clk = 0;
		forever #5 Clk = ~Clk;
	end

	// Test procedure
	initial begin
		// Initialize all signals
		we = 0;
		rs = 0;
		rt = 0;
		rd = 0;
		in = 0;

		// Wait a few clock cycles before starting
		#10;

		// === Test 1: Attempt to write to register 0 (should remain zero) ===
		$display("\n=== Test 1: Attempt to write to register 0 ===");
		we = 1;
		rd = 5'd0;             // Target register = 0
		in = 32'hFFFF_FFFF;    // Try to write a non-zero value
		#10;

		// Disable write and read from register 0
		we = 0;
		rs = 5'd0;
		#10;

		if (outA == 32'h0)
			$display("PASS: Register r0 is hardwired to 0 as expected.");
		else
			$display("FAIL: Register r0 is not 0. outA = %h", outA);

		// === Test 2: Write and read from register 1 ===
		$display("\n=== Test 2: Write and read from register 1 ===");
		we = 1;
		rd = 5'd1;
		in = 32'hAAAA_AAAA;
		#10;

		// Read from register 1 and 2
		we = 0;
		rs = 5'd1;
		rt = 5'd2;
		#10;

		$display("Read r1 -> outA = %h | Expected = %h", outA, 32'hAAAA_AAAA);
		$display("Read r2 -> outB = %h | Expected = %h", outB, 32'h0);

		// === Test 3: Write and read from register 2 ===
		$display("\n=== Test 3: Write and read from register 2 ===");
		we = 1;
		rd = 5'd2;
		in = 32'h5555_5555;
		#10;

		// Read again from register 1 and 2
		we = 0;
		rs = 5'd1;
		rt = 5'd2;
		#10;

		$display("Read r1 -> outA = %h | Expected = %h", outA, 32'hAAAA_AAAA);
		$display("Read r2 -> outB = %h | Expected = %h", outB, 32'h5555_5555);

		// === Finish simulation ===
		$display("\nSimulation completed.");
		$stop;
	end

endmodule
