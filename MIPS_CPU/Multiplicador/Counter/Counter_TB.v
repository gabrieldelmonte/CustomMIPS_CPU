`timescale 1ns/100ps

module Counter_TB();
	reg Clk;
	reg Load;
	wire K;

	/*
	module Counter (
		input Load, Clk,
		output K
	);
	*/

	Counter DUT (
		.Load(Load),
		.Clk(Clk),
		.K(K)
	);

	initial begin
		Clk = 0;
		forever #10 Clk = ~Clk;
	end

	initial begin
		Initialize();

		Load_Test();

		#100;

		Load_Test();

		#50;
		$finish;
	end

	task Initialize;
		begin
			Load = 0;
		end
	endtask

	task Load_Test;
		begin
			@(negedge Clk);
			$display("\n[%0t] Asserting Load (Reset Counter)", $time);
			Load = 1;

			@(posedge Clk);
			$display("[%0t] Load Applied. K=%b", $time, K);
			Load = 0;

			repeat (8) begin
				@(posedge Clk);
				$display("[%0t] Counting... K=%b", $time, K);
			end
		end
	endtask

endmodule
