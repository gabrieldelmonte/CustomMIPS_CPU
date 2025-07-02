module Multiplicador(
	input Clk,
	input St,
	input [15:0]Multiplicando,
	input [15:0]Multiplicador,

	output Done,
	output Idle,
	output [31:0]Produto
);

	wire [32:0]saidas;
	wire [16:0]Soma;
	
	wire Load;
	wire Ad;
	wire Sh;
	wire K;
	wire M;


// ACC
/*
module ACC (
	input Load, Sh, Ad, Clk, 
	input [32:0] Entradas,
	output [32:0] Saidas
);
*/
	assign Produto = saidas[31:0];
	ACC U0(.Load(Load), .Sh(Sh), .Ad(Ad), .Clk(Clk), .Entradas({Soma, Multiplicador}), .Saidas(saidas));


// ADDER
/*
module Adder (
	input [15:0] OperandoA, OperandoB,
	output [16:0] Soma
);
*/
	Adder U1(.OperandoA(Multiplicando), .OperandoB(saidas[31:16]), .Soma(Soma));


// CONTROL
/*
module CONTROL (
	input Clk, K, St, M,
	output Idle, Done, Load, Sh, Ad
);
*/
	assign M = saidas[0];
	CONTROL U2(.Clk(Clk), .K(K), .St(St), .M(M), .Idle(Idle), .Done(Done), .Load(Load), .Sh(Sh), .Ad(Ad));


// COUNTER
/*
module Counter (
	input Load, Clk,
	output K
);
*/
	Counter U3(.Load(Load), .Clk(Clk), .K(K));


endmodule
