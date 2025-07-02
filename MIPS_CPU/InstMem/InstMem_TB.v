`timescale 1ns / 1ps

module InstMem_TB();

	// Input signals
	reg [9:0] address;
	reg clock;
	reg [31:0] data;
	reg wren;

	// Output signal
	wire [31:0] q;

	// Instantiate the Unit Under Test (UUT)
	InstMem uut (
		.address(address),
		.clock(clock),
		.data(data),
		.wren(wren),
		.q(q)
	);

	// Clock generation: 50 MHz (20 ns period)
	initial begin
		clock = 0;
		forever #10 clock = ~clock;
	end

	// Stimulus
	initial begin
		// Inicialização
		address = 10'd0;
		data = 32'd0;   // não será usado (somente leitura)
		wren = 1'b0;    // desabilita escrita

		$display("Starting instruction memory simulation...");
		$monitor("Time: %0t | Address: %0d | Data (q): %h", $time, address, q);

		#30; // aguarda alguns ciclos

		// Leitura sequencial de endereços múltiplos de 4
		repeat (32) begin
			#20; // espera um ciclo
			address = address + 10'd4;
		end

		#50;
		$display("Simulation finished.");
		$stop;
	end

endmodule
