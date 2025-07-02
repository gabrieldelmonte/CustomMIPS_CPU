`timescale 1ns / 1ps

module pc_TB();
	reg clock, reset, zeroFlag, jmpFlag, branchFlag;
	reg [31:0] branchOffset, jmpAddress;
	wire [31:0] address;
	wire resetControl;

	// Instantiate the PC module
	pc uut (
		.clock(clock),
		.reset(reset),
		.zeroFlag(zeroFlag),
		.jmpFlag(jmpFlag),
		.branchFlag(branchFlag),
		.branchOffset(branchOffset),
		.jmpAddress(jmpAddress),
		.resetControl(resetControl),
		.address(address)
	);

	// Clock generation: 10ns period
	initial clock = 0;
	always #5 clock = ~clock;

	initial begin
		$display("\n=== PC Testbench Start ===");
		$monitor("Time: %0t | Addr: %h | Reset: %b | resetControl: %b | zeroFlag: %b | jmpFlag: %b | branchFlag: %b | Offset: %h | Jump: %h", 
		$time, address, reset, resetControl, zeroFlag, jmpFlag, branchFlag, branchOffset, jmpAddress);

		// Initialize inputs
		reset = 0;
		zeroFlag = 0;
		jmpFlag = 0;
		branchFlag = 0;
		branchOffset = 32'h00000008;
		jmpAddress   = 32'h00000ABC;

		// === Test 1: Reset ===
		reset = 1; #10;
		reset = 0; #10;

		// === Test 2: Normal increment ===
		#10;

		// === Test 3: Jump ===
		jmpFlag = 1;
		jmpAddress = 32'h00000FFF;
		#10;
		jmpFlag = 0;

		// === Test 4: Branch not taken (zeroFlag = 1) → skip branch ===
		branchFlag = 1;
		zeroFlag = 1;
		branchOffset = 32'hFFFFFFF8; // -8
		#10;
		branchFlag = 0;
		zeroFlag = 0;

		// === Test 5: Branch taken (zeroFlag = 0) → PC = PC + offset - 4 ===
		branchFlag = 1;
		zeroFlag = 0;
		branchOffset = 32'h00000010;
		#10;
		branchFlag = 0;

		// === Test 6: Reset ===
		reset = 1; #10;
		reset = 0; #10;

		// === Test 7: Normal increment again ===
		#10;

		$display("=== PC Testbench End ===\n");
		$stop;
	end

endmodule
