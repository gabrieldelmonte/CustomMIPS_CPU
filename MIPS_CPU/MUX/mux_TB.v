`timescale 1ns/1ps

module mux_TB();

    // Signal declarations for the testbench
    reg selector;     // Select signal
	reg [31:0] a;     // Input 0
    reg [31:0] b;     // Input 1
    wire [31:0] out;  // Output

    // Instantiate the mux module (Device Under Test - DUT)
    mux DUT (
        .a(a),
        .b(b),
        .selector(selector),
        .out(out)
    );

    // Test procedure
    initial begin
        // Monitor signal changes
        $monitor("Time = %0dns | a = %h, b = %h, selector = %b | out = %h", $time, a, b, selector, out);

        // Test 1: selector = 0, should pass input 'a' to output
        a = 32'hAAAAAAAA;
		b = 32'h55555555;
		selector = 0;
        #10;

        // Change 'a' while selector is still 0
        a = 32'h12345678;
        #10;

        // Test 2: selector = 1, should pass input 'b' to output
        selector = 1;
		b = 32'hFFEEDDCC;
        #10;

        // Change 'b' while selector is 1
        b = 32'hAABBCCDD;
        #10;

        // Test 3: Toggle selector to verify dynamic selection
        selector = 0;
        #10;
        selector = 1;
        #10;
        selector = 0;
        #10;

        // End simulation
        $stop;
    end

endmodule
