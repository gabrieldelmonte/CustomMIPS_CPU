module ADDRDecoding_Prog(
	input [31:0]address,
	output reg [31:0]iAddressInst,
	output reg CS_P
);

	reg [31:0]upper_address = 32'h1CBF;
	reg [31:0]lower_address = 32'h18C0;

	initial begin
		CS_P <= 0;
		iAddressInst <= 0;
	end

	always @(*) begin
		if (lower_address <= address && address <= upper_address) begin
			iAddressInst <= (address - lower_address) >> 2;
			CS_P <= 1;
		end
		else begin
			iAddressInst <= 0;
			CS_P <= 0;
		end
	end

endmodule
