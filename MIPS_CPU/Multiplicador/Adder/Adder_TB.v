`timescale 1ns/100ps

module Adder_TB();
	reg [3:0] OperandoA;
	reg [3:0] OperandoB;

	wire [4:0] Soma;

	/*
	module Adder (
		input [3:0] OperandoA, OperandoB,
		output [4:0] Soma
		);
	*/

	Adder DUT (
		.OperandoA(OperandoA),
		.OperandoB(OperandoB),
		.Soma(Soma)
	);

	initial begin
		Initialize();

		Add_Test(4'd3, 4'd5);	// 3 + 5 = 8
		Add_Test(4'd15, 4'd1);	// 15 + 1 = 16 (overflow check)
		Add_Test(4'd7, 4'd8);	// 7 + 8 = 15
		Add_Test(4'd0, 4'd0);	// 0 + 0 = 0
		Add_Test(4'd9, 4'd6);	// 9 + 6 = 15

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
		input [3:0] a, b;
		begin
			OperandoA = a;
			OperandoB = b;
			$display("[%0t] A=%d, B=%d, Soma=%d", $time, a, b, Soma);
		end
	endtask

endmodule
