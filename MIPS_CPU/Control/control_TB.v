`timescale 1ns / 1ps

module control_TB();

	// Input and output signals
	reg [31:0] input_data;
	wire [31:0] output_data;

	// Instantiate the control module
	control uut (
		.input_data(input_data),
		.output_data(output_data)
	);

	// Test sequence
	initial begin
		// Test 1: I-Type Instruction - LW (opcode 54)
		input_data = 32'b110110_00001_00010_0000000000000100; // LW r2, 4(r1)
		#10;
		$display("\n== LW Test ==");
		$display("Input:    %b", input_data);
		$display("Expected: [rs=00001][rt=00010][rd=00010][WR=1][Imm=1][ALU=00][MUL=0][MUX2=1][MEMWR=0][WB2=0][BR=0][JMP=0]");
		$display("Output:   %b", output_data);

		// Test 2: I-Type Instruction - SW (opcode 55)
		input_data = 32'b110111_00011_00100_0000000000000100; // SW r4, 4(r3)
		#10;
		$display("\n== SW Test ==");
		$display("Input:    %b", input_data);
		$display("Expected: [rs=00011][rt=00100][rd=00011][WR=0][Imm=1][ALU=00][MUL=0][MUX2=1][MEMWR=1][WB2=0][BR=0][JMP=0]");
		$display("Output:   %b", output_data);

		// Test 3: J-Type Instruction - JMP (opcode 2)
		input_data = 32'b000010_00000000000000000000000100; // JMP 4
		#10;
		$display("\n== JMP Test ==");
		$display("Input:    %b", input_data);
		$display("Expected: [rs=00000][rt=00000][rd=00000][WR=0][Imm=0][ALU=00][MUL=0][MUX2=1][MEMWR=0][WB2=0][BR=0][JMP=1]");
		$display("Output:   %b", output_data);

		// Test 4: R-Type Instruction - ADD (funct 32)
		input_data = 32'b000000_00101_00110_00111_00000_100000; // ADD r7, r5, r6
		#10;
		$display("\n== ADD (R-Type) Test ==");
		$display("Input:    %b", input_data);
		$display("Expected: [rs=00101][rt=00110][rd=00111][WR=1][Imm=0][ALU=00][MUL=0][MUX2=1][MEMWR=0][WB2=1][BR=0][JMP=0]");
		$display("Output:   %b", output_data);

		// Finish simulation
		#10 $stop;
	end

	// Monitor signals in real time
	initial begin
		$monitor("Time=%0t | input_data = %h | output_data = %b", $time, input_data, output_data);
	end

endmodule
