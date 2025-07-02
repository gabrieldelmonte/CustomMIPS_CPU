`timescale 1ns/100ps

module Multiplicador_TB();
	reg Clk;
	reg St;
	reg [15:0] Multiplicando;
	reg [15:0] Multiplicador;

	wire Done;
	wire Idle;
	wire [31:0] Produto;

	Multiplicador DUT (
		.Clk(Clk),
		.St(St),
		.Multiplicando(Multiplicando),
		.Multiplicador(Multiplicador),
		.Done(Done),
		.Idle(Idle),
		.Produto(Produto)
	);

	initial begin
		Clk = 0;
		forever #10 Clk = ~Clk;
	end

	initial begin
		Initialize();

		Multiply_Test(16'd3,  16'd5);	// 3 * 5 = 15
		Multiply_Test(16'd7,  16'd7); // 7 * 7 = 49
		Multiply_Test(16'd12, 16'd3); // 12 * 3 = 36

		#50;
		$finish;
	end

	task Initialize;
		begin
			St            = 0;
			Multiplicando = 0;
			Multiplicador = 0;
		end
	endtask

	task Multiply_Test;
		input [15:0] A;
		input [15:0] B;
		begin
			@(negedge Clk);
			Multiplicando = A;
			Multiplicador = B;
			$display("\n[%0t] Starting Multiply: A=%d, B=%d", $time, A, B);
			St = 1;

			@(posedge Done);
			$display("[%0t] Done! Produto=%d, Idle=%b", $time, Produto, Idle);
		end
	endtask

endmodule
