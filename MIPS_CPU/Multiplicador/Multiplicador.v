module Multiplicador(
	input Clk,
	input St,
	input reset,
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
	input [32:0] Entradas,
	input Ad,
	input Clk,
	input Load, 
	input Sh, 
	output reg [32:0] Saidas
);
*/
	assign Produto = saidas[31:0];
	ACC U0(.Load(Load), .Sh(Sh), .Ad(Ad), .Clk(Clk), .Entradas({Soma, Multiplicador}), .Saidas(saidas));


// ADDER
/*
module Adder (
	input [15:0] OperandoA,
	input [15:0] OperandoB,
	output [16:0] Soma
);
*/
	Adder U1(.OperandoA(Multiplicando), .OperandoB(saidas[31:16]), .Soma(Soma));


// CONTROL
/*
module CONTROL (
	input Clk, K, St, M, reset,
	output reg Idle, Done, Load, Sh, Ad
);
*/
	assign M = saidas[0];
	CONTROL U2(.Clk(Clk), .K(K), .St(St), .M(M), .reset(reset), .Idle(Idle), .Done(Done), .Load(Load), .Sh(Sh), .Ad(Ad));


// COUNTER
/*
module Counter (
	input Load, Clk, reset,
	output reg K
);
*/
	Counter U3(.Load(Load), .Clk(Clk), .reset(reset), .K(K));

endmodule
