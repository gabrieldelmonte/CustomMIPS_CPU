`timescale 1ns/1ps

module ADDRDecoding_Prog_TB();

    // Inputs
    reg [31:0] address;

    // Outputs
    wire CS_P;
    wire [31:0] iAddressInst;

    // Instantiate the Unit Under Test (UUT)
    ADDRDecoding_Prog uut (
        .address(address), 
        .CS_P(CS_P),
        .iAddressInst(iAddressInst)
    );

    // Test Cases
    initial begin
        // Test case 1: Address below lower_address (expected CS_P = 0)
        address = 32'h18BF;
        #10;
        $display("Address: %h, CS_P: %b, iAddressInst: %h (Expected CS_P: 0)", address, CS_P, iAddressInst);

        // Test case 2: Address equal to lower_address (expected CS_P = 1)
        address = 32'h18C0;
        #10;
        $display("Address: %h, CS_P: %b, iAddressInst: %h (Expected CS_P: 1)", address, CS_P, iAddressInst);

        // Test case 3: Address between lower_address and upper_address (expected CS_P = 1)
        address = 32'h1A00;
        #10;
        $display("Address: %h, CS_P: %b, iAddressInst: %h (Expected CS_P: 1)", address, CS_P, iAddressInst);

        // Test case 4: Address equal to upper_address (expected CS_P = 1)
        address = 32'h1CBF;
        #10;
        $display("Address: %h, CS_P: %b, iAddressInst: %h (Expected CS_P: 1)", address, CS_P, iAddressInst);

        // Test case 5: Address above upper_address (expected CS_P = 0)
        address = 32'h1CC0;
        #10;
        $display("Address: %h, CS_P: %b, iAddressInst: %h (Expected CS_P: 0)", address, CS_P, iAddressInst);

        // Finish the simulation
        $stop;
    end

endmodule
