/*



*/

module cpu(
	input CLK,
	input Reset,
	input [31:0]Data_BUS_READ,
	input [31:0]Prog_BUS_READ,
	output CS,
	output CS_P,
	output WE,
	output [31:0]ADDR,
	output [31:0]ADDR_Prog,
	output [31:0]Data_BUS_WRITE
);

    (*keep=1*)wire [31:0] dataOut_Inst_M;
    (*keep=1*)wire [31:0] addressCorrection_mem1, addressCorrection_mem2, dataOut_Imm;
    (*keep=1*)wire [31:0] dataOut_RF1, dataOut_RF2;
    (*keep=1*)wire [31:0] writeBack, register_A, register_B;
    (*keep=1*)wire [31:0] dataOut_M1, dataOut_M2, dataOut_M3;
    (*keep=1*)wire [31:0] dataOut_ALU, dataOut_Mult, dataOut_D1, dataOut_D2;
    (*keep=1*)wire [24:0] ctrl0, ctrl1, ctrl2;
    (*keep=1*)wire [25:0] ctrl3;
    (*keep=1*)wire [31:0] dataOut_PC;
    (*keep=1*)wire CLK_MUL, CLK_SYS;
    (*keep=1*)wire dataOut_M;
    (*keep=1*)wire [31:0] fioA, fioB;
    (*keep=1*)wire reset_control;
    (*keep=1*)wire zeroFlag;
    (*keep=1*)wire pc_jmpFlag;
    (*keep=1*)wire pc_branchFlag;
	
	(*keep=1*)wire done_mult;
	(*keep=1*)wire idle_mult;

    (*keep=1*)wire CS_WB;
    assign CS_WB = ctrl3[25];

	(*keep=1*)wire [31:0] tempOut;
	(*keep=1*)wire [31:0] dataOut_Extend;
	// WRITE_BACK 1
	  (*keep=1*)wire [31:0] dout;
	
	PLL pll (
		.inclk0 (CLK),
		.c0 (CLK_MUL),
		.c1 (CLK_SYS)
	);	
	
	assign ADDR = dataOut_D1;
	assign WE = ctrl1[3]; 
	assign ADDR_Prog = dataOut_PC;
	assign Data_BUS_WRITE = fioB;

//Instruction Fetch
	
	InstMem Intruction_Memory(
		.clock(CLK_SYS),
		.address(addressCorrection_mem1),
		.q(dataOut_Inst_M)
	);
		
	pc PC(
		.clock(CLK_SYS),
		.reset(Reset),
		.zeroFlag(zeroFlag),
		.jmpFlag(ctrl0[0]),
		.branchFlag(ctrl1[1]),
		.jmpAddress(dataOut_Extend),
		.branchOffset(dataOut_Imm),
		.address(dataOut_PC),
		.resetControl(reset_control)
	);
	
	mux MUX_ADDR(
		.selector(CS_P),
		.a(Prog_BUS_READ),
		.b(dataOut_Inst_M),
		.out(tempOut)
	);


	
	 
	 ADDRDecoding_Prog addrDecoding_Prog(
		.address(dataOut_PC),
		.iAddressInst(addressCorrection_mem1),
		.CS_P(CS_P)
	 );

	registerfile Register_File(
		.clock(CLK_SYS),
		.we(ctrl3[9]),
		.rs(ctrl0[24:20]),
		.rt(ctrl0[19:15]),
		.rd(ctrl3[14:10]),
		.input_data(writeBack),
		.output_data_A(fioA),
		.output_data_B(fioB),
		.reset(reset_control)
	);
	
	
		
	control Control(
		.input_data(tempOut),
		.output_data(ctrl0)
	);
	 
	extend Extend(
		.input_data(tempOut),
		.output_data(dataOut_Extend)
	);
	
	register IMM(
		.clock(CLK_SYS),
		.reset(reset_control),
		.input_data(dataOut_Extend),
		.output_data(dataOut_Imm)
	);
	


	register CTRL1 (
		.clock(CLK_SYS),
		.reset(reset_control),
		.input_data(ctrl0[24:0]),
		.output_data(ctrl1[24:0])
	);
	 
//Execute

	Multiplicador MULTIPLICADOR(
		.Clk(CLK_MUL),
		.St(ctrl1[5]),
		.Multiplicador(fioA[15:0]),
		.Multiplicando(fioB[15:0]),
		.Produto(dataOut_Mult),
		.Done(done_mult),
		.Idle(idle_mult)
	);
	
	mux MUX1(
		.selector(ctrl1[8]),
		.a(fioB),
		.b(dataOut_Imm),
		.out(dataOut_M1)
	);
	

	  
	alu ALU(
		.selector(ctrl1[7:6]),
		.input_data_A(fioA),
		.input_data_B(dataOut_M1),
		.output_data(dataOut_ALU),
		.zeroFlag(zeroFlag)
	);

	mux MUX2(
		.selector(ctrl1[4]),
		.a(dataOut_Mult),
		.b(dataOut_ALU),
		.out(dataOut_D1)
	);

//Memory 
	 wire iWE;
	ADDRDecoding ADDR_Decoding (
		.WE(ctrl1[3]),
		.iWE(iWE),
		.iAddress(addressCorrection_mem2),
		.address(dataOut_D1),
		.CS(CS)
	);

	
	datamemory Data_Memory (
		.clock(CLK_SYS), //
		.wren(iWE), // ok 
		.address(addressCorrection_mem2), 
		.data(fioB),
		.q(dout) // q
	);
	
	
	 
	mux MUX3(
		.selector(CS_WB),
		.a(Data_BUS_READ), // dout
		.b(dout), // Data_BUS_READ
		.out(dataOut_M3)
	);
	
		mux MUX4(
		.selector(ctrl3[2]),
		.a(dataOut_M3),
		.b(dataOut_D2), 
		.out(writeBack)
	);
	


	
	register D(
		.clock(CLK_SYS),
		.reset(Reset),
		.input_data(dataOut_D1),
		.output_data(dataOut_D2)
	);

	
   register CTRL3 (
        .clock(CLK_SYS),
        .reset(Reset),
        .input_data({CS,ctrl1[24:0]}),
        .output_data(ctrl3)
    );
 endmodule 