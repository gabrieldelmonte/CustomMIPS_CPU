module Adder (
	input [15:0] OperandoA, OperandoB,
	output [16:0] Soma
);

	assign Soma = (OperandoA + OperandoB);

endmodule
