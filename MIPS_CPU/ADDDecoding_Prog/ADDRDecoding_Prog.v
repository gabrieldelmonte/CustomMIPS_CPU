module ADDRDecoding_Prog(
	input [31:0]address,
	output reg [31:0]iAddressInst,
	output reg CS_P
);

	reg [31:0]upper_address;
	reg [31:0]lower_address;

	initial begin
		upper_address = 32'h1CBF;
		lower_address = 32'h18C0;

		iAddressInst = 32'h0;
		CS_P = 0;
	end

	always @(*) begin
		if (lower_address <= address && address <= upper_address) begin
			iAddressInst <= (address - lower_address);
			CS_P <= 1;
		end
		else begin
			iAddressInst <= 32'h0;
			CS_P <= 0;
		end
	end

endmodule
