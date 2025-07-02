`timescale 1ns/1ps

module alu_TB();

  // Testbench signals
  reg [31:0] input_data_A;
  reg [31:0] input_data_B;
  reg [1:0] selector;
  wire [31:0] output_data;
  wire zeroFlag;

  // Instantiate the ULA module
  alu uut (
    .input_data_A(input_data_A),
    .input_data_B(input_data_B),
    .selector(selector),
    .output_data(output_data),
    .zeroFlag(zeroFlag)
  );

  // Test sequence
  initial begin
    $display("\n=== ULA Testbench Start ===");
    $monitor("Time: %0t | A = %h | B = %h | selector = %b | result = %h | zeroFlag = %b", 
              $time, input_data_A, input_data_B, selector, output_data, zeroFlag);

    // Test 1: A + B
    input_data_A = 32'h0000_0005;
    input_data_B = 32'h0000_0003;
    selector = 2'b00; // ADD
    #10;

    // Test 2: A - B (positive result)
    input_data_A = 32'h0000_000A;
    input_data_B = 32'h0000_0003;
    selector = 2'b01; // SUB
    #10;

    // Test 3: A - B (zero result)
    input_data_A = 32'h1234_5678;
    input_data_B = 32'h1234_5678;
    selector = 2'b01; // SUB
    #10;

    // Test 4: A & B (bitwise AND)
    input_data_A = 32'hFF00_FF00;
    input_data_B = 32'h0F0F_0F0F;
    selector = 2'b10; // AND
    #10;

    // Test 5: A | B (bitwise OR)
    input_data_A = 32'h0000_00F0;
    input_data_B = 32'h0000_000F;
    selector = 2'b11; // OR
    #10;

    // Test 6: A + B = 0 (test zero flag)
    input_data_A = 32'hFFFF_FFFF;
    input_data_B = 32'h0000_0001;
    selector = 2'b00; // ADD
    #10;

	// End simulation
    $display("=== ULA Testbench End ===\n");
    $stop;
  end

endmodule
