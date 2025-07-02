`timescale 1ns/100ps

module ADDRDecoding_TB();

	reg [31:0] address;
	reg WE;
	wire CS;
	wire iWE;
	wire [31:0] iAddress;

	// Instantiate the Unit Under Test (UUT)
	ADDRDecoding uut (
		.address(address),
		.WE(WE),
		.CS(CS),
		.iWE(iWE),
		.iAddress(iAddress)
	);

	initial begin
		// Initialize inputs
		address = 32'h00000000;
		WE = 0;

		$display("\n=== ADDRDecoding Testbench Start ===");

		// Test 1: Address within the valid range
		#10 address = 32'h8F20; WE = 1; #10;
		// Expected: CS = 1, iWE = 1, iAddress = 32'h0000000F
		$display("Test 1 | Addr: %h | CS: %b (Expected: 1) | iWE: %b (Expected: 1) | iAddress: %h (Expected: 0000000F)", 
		address, CS, iWE, iAddress);

		// Test 2: Lower boundary of range
		#10 address = 32'h8F11; WE = 1; #10;
		// Expected: CS = 1, iWE = 1, iAddress = 0
		$display("Test 2 | Addr: %h | CS: %b (Expected: 1) | iWE: %b (Expected: 1) | iAddress: %h (Expected: 00000000)", 
		address, CS, iWE, iAddress);

		// Test 3: Upper boundary of range
		#10 address = 32'h9310; WE = 1; #10;
		// Expected: CS = 1, iWE = 1, iAddress = 0x3FF
		$display("Test 3 | Addr: %h | CS: %b (Expected: 1) | iWE: %b (Expected: 1) | iAddress: %h (Expected: 000003FF)", 
		address, CS, iWE, iAddress);

		// Test 4: Address below range
		#10 address = 32'h8F00; WE = 1; #10;
		// Expected: CS = 0, iWE = 0, iAddress = 0
		$display("Test 4 | Addr: %h | CS: %b (Expected: 0) | iWE: %b (Expected: 0) | iAddress: %h (Expected: 00000000)", 
		address, CS, iWE, iAddress);

		// Test 5: Address above range
		#10 address = 32'h9320; WE = 1; #10;
		// Expected: CS = 0, iWE = 0, iAddress = 0
		$display("Test 5 | Addr: %h | CS: %b (Expected: 0) | iWE: %b (Expected: 0) | iAddress: %h (Expected: 00000000)", 
		address, CS, iWE, iAddress);

		// Test 6: Address in range but WE = 0
		#10 address = 32'h9000; WE = 0; #10;
		// Expected: CS = 1, iWE = 0, iAddress = 0x00EF
		$display("Test 6 | Addr: %h | CS: %b (Expected: 1) | iWE: %b (Expected: 0) | iAddress: %h (Expected: 000000EF)", 
		address, CS, iWE, iAddress);

		$display("=== ADDRDecoding Testbench End ===\n");
		$stop;
	end

endmodule
