module Adder (
	input [3:0] OperandoA, OperandoB,
	output [4:0] Soma
);

	assign Soma = (OperandoA + OperandoB);

endmodule
