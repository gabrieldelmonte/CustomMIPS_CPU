`timescale 1ns/100ps

module ACC_TB();
	reg Clk;
	reg Sh;
	reg Ad;
	reg Load;
	reg [8:0] Entradas;

	wire [8:0] Saidas;

	/*
	module ACC (
		input Load, Sh, Ad, Clk, 
		input [8:0] Entradas,
		output [8:0] Saidas
	);	
	*/

	ACC DUT (
		.Load(Load),
		.Sh(Sh),
		.Ad(Ad),
		.Clk(Clk),
		.Entradas(Entradas),
		.Saidas(Saidas)
	);

	initial begin
		Clk = 0;
		forever #10 Clk = ~Clk;
	end

	initial begin
		Initialize();

		Load_Test(7);
		Shift_Test(1);
		Add_Test(200);

		#30;
		$finish;
	end

	task Initialize;
		begin
			Sh = 0;
			Ad = 0;
			Load = 0;
			Entradas = 0;
		end
	endtask

	task Load_Test;
		input [8:0] data;
		begin
			@(negedge Clk);
			$display("\n[%0t] Starting Load Test", $time);
			Load = 1;
			Entradas = data;

			@(posedge Clk);
			$display("[%0t] Data Loaded: Input=%d, Output=%d", 
			$time, Entradas, Saidas);
			Load = 0;
		end
	endtask

	task Shift_Test;
		input [8:0] data;
		begin
			@(negedge Clk);
			$display("\n[%0t] Starting Shift Test", $time);
			Sh = 1;
			Entradas = data;

			@(posedge Clk);
			$display("[%0t] After Shift: Output=%d", $time, Saidas);
			Sh = 0;
		end
	endtask

	task Add_Test;
		input [8:0] data;
		begin
			@(negedge Clk);
			$display("\n[%0t] Starting Add Test", $time);
			Ad = 1;
			Entradas = data;

			@(posedge Clk);
			$display("[%0t] After Add: Output=%d", $time, Saidas);
			Ad = 0;
		end
	endtask

endmodule
