`timescale 1ns/100ps

module CONTROL_TB();
	reg Clk;
	reg K;
	reg St;
	reg M;

	wire Idle;
	wire Done;
	wire Load;
	wire Sh;
	wire Ad;

	/*
	module CONTROL (
		input Clk, K, St, M,
		output reg Idle, Done, Load, Sh, Ad
	);
	*/

	CONTROL DUT (
		.Clk(Clk),
		.K(K),
		.St(St),
		.M(M),
		.Idle(Idle),
		.Done(Done),
		.Load(Load),
		.Sh(Sh),
		.Ad(Ad)
	);

	initial begin
		Clk = 0;
		forever #10 Clk = ~Clk;
	end

	initial begin
		Initialize();

		@(negedge Clk);
		Start_Test();

		@(negedge Clk);
		M_Test(1);

		@(negedge Clk);
		Next_Cycle();

		@(negedge Clk);
		K_Test(1);

		@(negedge Clk);
		Idle_Check();

		#30;
		$finish;
	end

	task Initialize;
		begin
			K = 0;
			St = 0;
			M = 0;
		end
	endtask

	task Start_Test;
		begin
			St = 1;
			$display("\n[%0t] Starting - Set St=1", $time);
			@(posedge Clk);
			$display("[%0t] State: Idle=%b Load=%b", $time, Idle, Load);
			St = 0;
		end
	endtask

	task M_Test;
		input val;
		begin
			M = val;
			$display("\n[%0t] M_Test with M=%b", $time, M);
			@(posedge Clk);
			$display("[%0t] State: Ad=%b", $time, Ad);
		end
	endtask

	task Next_Cycle;
		begin
			$display("\n[%0t] Advancing to Sh", $time);
			@(posedge Clk);
			$display("[%0t] State: Sh=%b", $time, Sh);
		end
	endtask

	task K_Test;
		input val;
		begin
			K = val;
			$display("\n[%0t] K_Test with K=%b", $time, K);
			@(posedge Clk);
			$display("[%0t] State: Done=%b", $time, Done);
			K = 0;
		end
	endtask

	task Idle_Check;
		begin
			@(posedge Clk);
			$display("\n[%0t] Final Idle State: Idle=%b", $time, Idle);
		end
	endtask

endmodule
