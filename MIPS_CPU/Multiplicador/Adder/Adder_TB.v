`timescale 1ns/100ps

module Adder_TB();
	reg [15:0] OperandoA;
	reg [15:0] OperandoB;

	wire [16:0] Soma;

	/*
	module Adder (
		input [15:0] OperandoA, OperandoB,
		output [16:0] Soma
		);
	*/

	Adder DUT (
		.OperandoA(OperandoA),
		.OperandoB(OperandoB),
		.Soma(Soma)
	);

	initial begin
		Initialize();

		Add_Test(16'd3, 16'd5);	// 3 + 5 = 8
		Add_Test(16'd15, 16'd1);	// 15 + 1 = 16 (overflow check)
		Add_Test(16'd7, 16'd8);	// 7 + 8 = 15
		Add_Test(16'd0, 16'd0);	// 0 + 0 = 0
		Add_Test(16'd9, 16'd6);	// 9 + 6 = 15

		#30;
		$finish;
	end

	task Initialize;
		begin
			OperandoA = 0;
			OperandoB = 0;
		end
	endtask

	task Add_Test;
		input [15:0] a, b;
		begin
			OperandoA = a;
			OperandoB = b;
			$display("[%0t] A=%d, B=%d, Soma=%d", $time, a, b, Soma);
		end
	endtask

endmodule
