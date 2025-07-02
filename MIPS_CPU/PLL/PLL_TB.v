`timescale 1ns/100ps

module PLL_TB();

	reg CLK;              // Clock de entrada
	wire CLK_MUL;         // Clock multiplicado (saída da PLL)
	wire CLK_SYS;         // Clock do sistema (saída da PLL)

	// Instancia o módulo PLL
	PLL DUT (
		.inclk0(CLK),     // Clock de entrada
		.c0(CLK_MUL),     // Saída 1
		.c1(CLK_SYS)      // Saída 2
	);

	// Gera clock de entrada de 50 MHz (período de 20ns)
	initial CLK = 1'b0;
	always #10 CLK = ~CLK;

	// Finaliza a simulação após 4000ns
	initial begin
		$display("=== PLL Testbench Start ===");
		$monitor("Time: %0t | CLK: %b | CLK_MUL: %b | CLK_SYS: %b", 
		$time, CLK, CLK_MUL, CLK_SYS);
		#4000;
		$display("=== PLL Testbench End ===");
		$stop;
	end

endmodule
