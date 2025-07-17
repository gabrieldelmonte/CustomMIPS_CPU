/*
Discentes:
	* Gabriel Del Monte Schiavi Noda - 2022014552
	* Gabrielle Gomes Almeida		 - 2022002758
	* Leonardo Jose Siqueira Marinho - 2022009730

FPGA: Intel Cyclone IV GX EP4CGX150DF31I7AD.

Perguntas:
a. A latencia do sistema foi definida como 5 periodos de clock.

b. O throughput do sistema pode ser definido como 32 bits / (CLK_SYS).

c. A frequencia maxima para o multiplicador foi: 306,18 MHz. E para o sistema foi: 50,11 MHz.

d. A frequencia maxima de operacao do circuito foi calculada como: 12,24 MHz.

e. Nao havera problemas de metaestabilidade, especialmente pois a frequencia de operacao dos dois circuitos
	sao multiplas, o que garante o funcionamento correto da PLL utilizada no projeto.

f. A utilizacao deste multiplicador nao se torna a mais eficiente para o sistema como um todo. De fato, em termos
	de simplicidade, o multiplicador aplicado se torna a melhor escolha porem considerando outros pontos, como por
	exemplo, velocidade de circuito, o multiplicador nao se torna a melhor escolha por necessitar de varios ciclos
	de clock para realizar suas operacoes.

g. A principal sugestao para o circuito implementado seria a adocao de um pipeline desenrolado, tornando-se em um
	circuito combinacional. A nova latencia do circuito seria igual a 5 pulsos de clock, com um throughput de
	32 bits / CLK_SYS porem traria uma grande desvantagem em relacao a area do circuito.
*/

module cpu(
    input [31:0]Data_BUS_READ,
    input [31:0]Prog_BUS_READ,
    input CLK,
    input Reset,
    output [31:0]ADDR,
    output [31:0]ADDR_Prog,
    output [31:0]Data_BUS_WRITE,
    output CS,
    output CS_P,
    output WE
);

	//

	(*keep = 1*)wire [31:0]address_Data_M;
	(*keep = 1*)wire [31:0]address_Inst_M;
	(*keep = 1*)wire [31:0]dataOut_ALU;
	(*keep = 1*)wire [31:0]dataOut_D1;
	(*keep = 1*)wire [31:0]dataOut_D2;
	(*keep = 1*)wire [31:0]dataOut_Extend;
	(*keep = 1*)wire [31:0]dataOut_Imm;
	(*keep = 1*)wire [31:0]dataOut_Inst_M;
	(*keep = 1*)wire [31:0]dataOut_M1;
	(*keep = 1*)wire [31:0]dataOut_M2;
	(*keep = 1*)wire [31:0]dataOut_M3;
	(*keep = 1*)wire [31:0]dataOut_Mult;
	(*keep = 1*)wire [31:0]dataOut_PC;
	(*keep = 1*)wire [31:0]dataOut_RF1;
	(*keep = 1*)wire [31:0]dataOut_RF2;
	(*keep = 1*)wire [31:0]dout;
	(*keep = 1*)wire [31:0]register_A;
	(*keep = 1*)wire [31:0]register_B;
	(*keep = 1*)wire [31:0]tempOut;
	(*keep = 1*)wire [31:0]wire_A;
	(*keep = 1*)wire [31:0]wire_B;
	(*keep = 1*)wire [31:0]writeBack;

	(*keep = 1*)wire [25:0]ctrl3;

	(*keep = 1*)wire [24:0]ctrl0;
	(*keep = 1*)wire [24:0]ctrl1;
	(*keep = 1*)wire [24:0]ctrl2;

	(*keep = 1*)wire CLK_MUL;
	(*keep = 1*)wire CLK_SYS;
	(*keep = 1*)wire CS_WB;
	(*keep = 1*)wire dataOut_M;
	(*keep = 1*)wire iWE;
	(*keep = 1*)wire pc_branchFlag;
	(*keep = 1*)wire pc_jmpFlag;
	(*keep = 1*)wire reset_control;
	(*keep = 1*)wire zeroFlag;

	//

	assign ADDR = dataOut_D1;
	assign ADDR_Prog = dataOut_PC;
	assign CS_WB = ctrl3[25];
	assign Data_BUS_WRITE = wire_B;
	assign WE = ctrl1[3];

	//

/*
	PLL(
		inclk0,
		c0,
		c1
	);
*/
	PLL pll(
		.inclk0 (CLK),
		.c0 (CLK_MUL),
		.c1 (CLK_SYS)
	);


	//
	// Instruction Fetch
	//

/*
	InstMem(
		address,
		clock,
		data,
		wren,
		q
	);
*/
	InstMem Intruction_Memory(
		.address(address_Inst_M),
		.clock(CLK_SYS),
		.q(dataOut_Inst_M)
	);

/*
	pc(
		input [31:0]branchOffset,
		input [31:0]jmpAddress,
		input branchFlag,
		input clock,
		input jmpFlag,
		input reset,
		input zeroFlag,
		output reg [31:0]address,
		output reg resetControl
	);
*/
	pc PC(
		.branchOffset(dataOut_Imm),
		.jmpAddress(dataOut_Extend),
		.branchFlag(ctrl1[1]),
		.clock(CLK_SYS),
		.jmpFlag(ctrl0[0]),
		.reset(Reset),
		.zeroFlag(zeroFlag),
		.address(dataOut_PC),
		.resetControl(reset_control)
	);

/*
	mux(
		input wire [31:0]a,
		input wire [31:0]b,
		input wire selector,
		output wire [31:0]out
	);
*/
	mux MUX_ADDR(
		.a(Prog_BUS_READ),
		.b(dataOut_Inst_M),
		.selector(CS_P),
		.out(tempOut)
	);

/*
	ADDRDecoding_Prog(
		input [31:0]address,
		output reg [31:0]iAddressInst,
		output reg CS_P
	);
*/
	ADDRDecoding_Prog addrDecoding_Prog(
		.address(dataOut_PC),
		.iAddressInst(address_Inst_M),
		.CS_P(CS_P)
	);


	//
	// Instruction Decode
	//

/*
	registerfile(
		input [31:0]input_data,
		input [4:0]rd,
		input [4:0]rs,
		input [4:0]rt,
		input clock,
		input we,
		input resetControl,
		output reg [31:0]output_data_A,
		output reg [31:0]output_data_B
	);
*/
	registerfile Register_File(
		.input_data(writeBack),
		.rd(ctrl3[14:10]),
		.rs(ctrl0[24:20]),
		.rt(ctrl0[19:15]),
		.clock(CLK_SYS),
		.we(ctrl3[9]),
		.resetControl(reset_control),
		.output_data_A(wire_A),
		.output_data_B(wire_B)
	);

/*
	control(
		input [31:0]input_data,
		output [24:0]output_data
	);
*/
	control Control(
		.input_data(tempOut),
		.output_data(ctrl0)
	);

/*
	extend(
		input [15:0]input_data,
		output reg [31:0]output_data
	);
*/
	extend Extend(
		.input_data(tempOut),
		.output_data(dataOut_Extend)
	);

/*
	register #(parameter DATA_WIDTH = 32)(
		input [(DATA_WIDTH - 1):0]input_data,
		input clock,
		input reset,
		output reg [(DATA_WIDTH - 1):0]output_data
	);
*/
	register IMM(
		.input_data(dataOut_Extend),
		.clock(CLK_SYS),
		.reset(reset_control),
		.output_data(dataOut_Imm)
	);

/*
	register #(parameter DATA_WIDTH = 32)(
		input [(DATA_WIDTH - 1):0]input_data,
		input clock,
		input reset,
		output reg [(DATA_WIDTH - 1):0]output_data
	);
*/
	register CTRL1(
		.input_data(ctrl0[24:0]),
		.clock(CLK_SYS),
		.reset(reset_control),
		.output_data(ctrl1[24:0])
	);


	//
	// Execute
	//

/*
	Multiplicador(
		input Clk,
		input St,
		input reset,
		input [15:0]Multiplicando,
		input [15:0]Multiplicador,

		output Done,
		output Idle,
		output [31:0]Produto
	);
*/
	Multiplicador MULTIPLICADOR(
		.Clk(CLK_MUL),
		.St(ctrl1[5]),
		.reset(reset_control),
		.Multiplicando(wire_B[15:0]),
		.Multiplicador(wire_A[15:0]),
		.Produto(dataOut_Mult)
	);

/*
	mux(
		input wire [31:0]a,
		input wire [31:0]b,
		input wire selector,
		output wire [31:0]out
	);
*/
	mux MUX1(
		.a(wire_B),
		.b(dataOut_Imm),
		.selector(ctrl1[8]),
		.out(dataOut_M1)
	);

/*
alu(
	input [31:0]input_data_A,
	input [31:0]input_data_B,
	input [1:0]selector,
	output reg [31:0]output_data,
	output zeroFlag
);
*/
	alu ALU(
		.input_data_A(wire_A),
		.input_data_B(dataOut_M1),
		.selector(ctrl1[7:6]),
		.output_data(dataOut_ALU),
		.zeroFlag(zeroFlag)
	);

/*
	mux(
		input wire [31:0]a,
		input wire [31:0]b,
		input wire selector,
		output wire [31:0]out
	);
*/
	mux MUX2(
		.a(dataOut_Mult),
		.b(dataOut_ALU),
		.selector(ctrl1[4]),
		.out(dataOut_D1)
	);


	//
	// Memory
	//

/*
	module ADDRDecoding(
		input [31:0]address,
		input WE,
		output reg [31:0]iAddress,
		output reg CS,
		output reg iWE
	);
*/
	ADDRDecoding ADDR_Decoding(
		.address(dataOut_D1),
		.WE(ctrl1[3]),
		.iAddress(address_Data_M),
		.CS(CS),
		.iWE(iWE)
	);

/*
	datamemory (
		address,
		clock,
		data,
		wren,
		q
	);
*/
	datamemory Data_Memory (
		.address(address_Data_M),
		.clock(CLK_SYS),
		.data(wire_B),
		.wren(iWE),
		.q(dout)
	);

/*
	mux(
		input wire [31:0]a,
		input wire [31:0]b,
		input wire selector,
		output wire [31:0]out
	);
*/
	mux MUX3(
		.a(Data_BUS_READ),
		.b(dout),
		.selector(CS_WB),
		.out(dataOut_M3)
	);

/*
	mux(
		input wire [31:0]a,
		input wire [31:0]b,
		input wire selector,
		output wire [31:0]out
	);
*/
	mux MUX4(
		.a(dataOut_M3),
		.b(dataOut_D2),
		.selector(ctrl3[2]),
		.out(writeBack)
	);

/*
	register #(parameter DATA_WIDTH = 32)(
		input [(DATA_WIDTH - 1):0]input_data,
		input clock,
		input reset,
		output reg [(DATA_WIDTH - 1):0]output_data
	);
*/
	register D(
		.input_data(dataOut_D1),
		.clock(CLK_SYS),
		.reset(Reset),
		.output_data(dataOut_D2)
	);

/*
	register #(parameter DATA_WIDTH = 32)(
		input [(DATA_WIDTH - 1):0]input_data,
		input clock,
		input reset,
		output reg [(DATA_WIDTH - 1):0]output_data
	);
*/
	register #(26) CTRL3 (
		.input_data({CS, ctrl1[24:0]}),
		.clock(CLK_SYS),
		.reset(Reset),
		.output_data(ctrl3)
	);

endmodule

