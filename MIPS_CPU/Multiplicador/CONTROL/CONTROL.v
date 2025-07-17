module CONTROL (
	input Clk, K, St, M, reset,
	output reg Idle, Done, Load, Sh, Ad
);

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11; 

	reg [1:0] state = S0;

	always @(M, St, state) begin
		Idle <= 0;
		Load <= 0;
		Sh 	 <= 0;
		Ad 	 <= 0;
		Done <= 0;
		case (state)
			S0: begin
				if (St)
					Load <= 1;
				else
					Idle <= 1;
			end
			S1:
				if (M)
					Ad <= 1;
			S2:
				Sh <= 1;
			S3:
				Done <= 1;
			default:
				Idle <= 1;
		endcase
	end

	always @(posedge Clk, posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				S0: 	 state <= ((St) ? S1 : S0);
				S1:		 state <= S2;
				S2: 	 state <= ((K) ? S3 : S1);
				S3: 	 state <= S0;
				default: state <= S0;
			endcase
	end

endmodule
