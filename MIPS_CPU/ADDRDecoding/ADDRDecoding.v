module ADDRDecoding(
	input [31:0]address,
	input WE,
	output reg [31:0]iAddress,
	output reg CS,
	output reg iWE
);

	reg [31:0]upper_address;
	reg [31:0]lower_address;

	initial begin
		upper_address = 32'h1D2D;
		lower_address = 32'h192E;

		iAddress = 32'h0;
		CS = 0;
		iWE = 0;
	end

	always @(*) begin
		if (lower_address <= address && address <= upper_address) begin
			iAddress <= (address - lower_address);
			CS <= 1;
			iWE <= WE;
		end
		else begin
			iAddress <= 32'h0;
			CS <= 0;
			iWE <= 0;
		end
	end

endmodule
