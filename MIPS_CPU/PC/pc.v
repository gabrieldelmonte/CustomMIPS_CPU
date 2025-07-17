module pc(
	input [31:0]branchOffset,
	input [31:0]jmpAddress,
	input branchFlag,
	input clock,
	input jmpFlag,
	input reset,
	input zeroFlag,
	output reg [31:0]address,
	output reg resetControl
);

	always @(posedge clock, posedge reset) begin
		if (reset) begin
			address <= 32'h18C0;
			resetControl <= 0;
		end
		else if (jmpFlag) begin
			address <= (32'h18C0 + jmpAddress);
			resetControl <= 0;
		end
		else if (branchFlag && !zeroFlag) begin
			address <= (address + $signed(branchOffset) - 4);
			resetControl <= 1;
		end
		else begin
			address <= (address + 4);
			resetControl <= 0;
		end
	end

endmodule
