module pc(
	input clock,
	input reset,
	input zeroFlag,
	input jmpFlag,
	input branchFlag,
	input [31:0]branchOffset,
	input [31:0]jmpAddress,
	output reg resetControl,
	output reg [31:0]address
);

	always @(posedge clock, posedge reset) begin
		if (reset) begin
			address <= 32'h18C0;
			//address <= 32'h0;
			resetControl <= 0;
		end
		else if (jmpFlag) begin
			address <= 32'h18C0 + jmpAddress;
			//address <= jmpAddress;
			resetControl <= 0;
		end
		else if (branchFlag && !zeroFlag) begin
			address <= address + $signed(branchOffset) - 4;
			resetControl <= 1;
		end
		else begin
			address <= address + 4;
			resetControl <= 0;
		end
	end

endmodule
