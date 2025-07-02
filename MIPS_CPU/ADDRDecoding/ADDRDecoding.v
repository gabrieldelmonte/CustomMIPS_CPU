module ADDRDecoding(
	input WE,
	input [31:0]address,
	output reg CS,
	output reg iWE,
	output reg [31:0]iAddress
);
	
	reg [31:0]upper_address = 32'h1D2D;
	reg [31:0]lower_address = 32'h192E;

	initial begin
		CS = 0;
		iWE = 0;
		iAddress = 32'h0;
	end

	always @(*) begin
		if (lower_address <= address && address <= upper_address) begin
			CS = 1;
			iWE = WE;
			iAddress = (address - lower_address);
		end
		else begin
			CS = 0;
			iWE = 0;
			iAddress = 32'h0;
		end	
	end

endmodule
