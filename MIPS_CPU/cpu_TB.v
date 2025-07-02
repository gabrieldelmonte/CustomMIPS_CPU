`timescale 1ns / 1ps

module cpu_TB();

    reg CLK, Reset;
    reg [31:0] Data_BUS_READ, Prog_BUS_READ;
    reg CLK_SYS, CLK_MUL;
    reg [31:0] writeBack;

    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog;
    wire CS, WE, CS_P;

    // Instância do módulo CPU
    cpu dut (
        .CLK(CLK),
        .Reset(Reset),
        .Data_BUS_READ(Data_BUS_READ),
        .Prog_BUS_READ(Prog_BUS_READ),
        .ADDR(ADDR),
        .Data_BUS_WRITE(Data_BUS_WRITE),
        .ADDR_Prog(ADDR_Prog),
        .CS(CS),
        .WE(WE),
        .CS_P(CS_P)
    );

    initial begin
        // Sinais principais para análise no ModelSim
        $init_signal_spy("dut/CLK_SYS", "CLK_SYS", 1);
        $init_signal_spy("dut/CLK_MUL", "CLK_MUL", 1);
        $init_signal_spy("dut/writeBack", "writeBack", 1);
        $init_signal_spy("dut/fioA", "fioA", 1);
        $init_signal_spy("dut/fioB", "fioB", 1);
        $init_signal_spy("dut/dataOut_ALU", "dataOut_ALU", 1);
        $init_signal_spy("dut/dataOut_Mult", "dataOut_Mult", 1);
        $init_signal_spy("dut/dataOut_D1", "dataOut_D1", 1);
        $init_signal_spy("dut/dataOut_D2", "dataOut_D2", 1);
        $init_signal_spy("dut/dataOut_PC", "dataOut_PC", 1);
        $init_signal_spy("dut/dataOut_M3", "dataOut_M3", 1);
        $init_signal_spy("dut/dout", "mem_q", 1);
        $init_signal_spy("dut/ctrl0", "ctrl0", 1);
        $init_signal_spy("dut/ctrl1", "ctrl1", 1);
        $init_signal_spy("dut/ctrl3", "ctrl3", 1);
        $init_signal_spy("dut/zeroFlag", "zeroFlag", 1);
        $init_signal_spy("dut/reset_control", "reset_control", 1);
        $init_signal_spy("dut/tempOut", "tempOut", 1);
        $init_signal_spy("dut/dataOut_Inst_M", "inst_mem_out", 1);
        $init_signal_spy("dut/addrDecoding_Prog/iAddressInst", "iAddressInst", 1);
        
        // Sinais específicos do multiplicador para depuração
        $init_signal_spy("dut/MULTIPLICADOR/St", "mult_start", 1);
        $init_signal_spy("dut/MULTIPLICADOR/Multiplicando", "mult_multiplicando", 1);
        $init_signal_spy("dut/MULTIPLICADOR/Multiplicador", "mult_multiplicador", 1);
        $init_signal_spy("dut/MULTIPLICADOR/Produto", "mult_produto", 1);
        $init_signal_spy("dut/MULTIPLICADOR/Done", "mult_done", 1);
        $init_signal_spy("dut/MULTIPLICADOR/Idle", "mult_idle", 1);
        $init_signal_spy("dut/done_mult", "done_mult", 1);
        $init_signal_spy("dut/idle_mult", "idle_mult", 1);

        CLK = 0;
        Reset = 1;
        Data_BUS_READ = 32'hFFFFFFFF;
        Prog_BUS_READ = 32'h00000000;

        #10 Reset = 0;

        #16000 $stop;
    end

    // Clock de 10 unidades de tempo
    always #5 CLK = ~CLK;

    // Monitor específico para multiplicação
    always @(posedge dut.MULTIPLICADOR.St) begin
        $display("=== MULTIPLICAÇÃO INICIADA ===");
        $display("Time: %0t", $time);
        $display("Multiplicando: %h (%d)", dut.MULTIPLICADOR.Multiplicando, dut.MULTIPLICADOR.Multiplicando);
        $display("Multiplicador: %h (%d)", dut.MULTIPLICADOR.Multiplicador, dut.MULTIPLICADOR.Multiplicador);
        $display("===============================");
    end

    always @(posedge dut.done_mult) begin
        $display("=== MULTIPLICAÇÃO FINALIZADA ===");
        $display("Time: %0t", $time);
        $display("Produto: %h (%d)", dut.dataOut_Mult, dut.dataOut_Mult);
        $display("=================================");
    end

    // Impressão de sinais a cada subida de clock
    always @(posedge CLK) begin
        $display("Time: %0t", $time);
        $display("ADDR = %h | WE = %b | CS = %b | Data_BUS_WRITE = %h", ADDR, WE, CS, Data_BUS_WRITE);
        $display("ADDR_Prog = %h | CS_P = %b", ADDR_Prog, CS_P);
        $display("Instr = %h | tempOut = %h", dut.dataOut_Inst_M, dut.tempOut);
        $display("fioA = %h | fioB = %h", dut.fioA, dut.fioB);
        $display("ALU = %h | MULT = %h", dut.dataOut_ALU, dut.dataOut_Mult);
        $display("D1 = %h | D2 = %h", dut.dataOut_D1, dut.dataOut_D2);
        $display("writeBack = %h | dout(mem) = %h", dut.writeBack, dut.dout);
        $display("CTRL0 = %b | CTRL1 = %b | CTRL3 = %b", dut.ctrl0, dut.ctrl1, dut.ctrl3);
        $display("Zero = %b | Reset_Ctrl = %b", dut.zeroFlag, dut.reset_control);
        $display("iAddressInst = %h", dut.addrDecoding_Prog.iAddressInst);
        // Informações detalhadas do multiplicador
        $display("MULT_START = %b | MULT_DONE = %b | MULT_IDLE = %b", dut.MULTIPLICADOR.St, dut.done_mult, dut.idle_mult);
        $display("MULT_A = %h | MULT_B = %h | MULT_PRODUTO = %h", dut.MULTIPLICADOR.Multiplicando, dut.MULTIPLICADOR.Multiplicador, dut.dataOut_Mult);
        $display("CTRL1[5] (Start) = %b | CLK_MUL = %b", dut.ctrl1[5], dut.CLK_MUL);
        $display("-------------------------------------------");
    end

endmodule


/*
`timescale 1ns / 1ps

module cpu_TB();

    reg CLK, Reset;
    reg [31:0] Data_BUS_READ, Prog_BUS_READ;
    reg CLK_SYS, CLK_MUL;
    reg [31:0] writeBack;

    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog;
    wire CS, WE, CS_P;

    // Instância do módulo CPU
    cpu dut (
        .CLK(CLK),
        .Reset(Reset),
        .Data_BUS_READ(Data_BUS_READ),
        .Prog_BUS_READ(Prog_BUS_READ),
        .ADDR(ADDR),
        .Data_BUS_WRITE(Data_BUS_WRITE),
        .ADDR_Prog(ADDR_Prog),
        .CS(CS),
        .WE(WE),
        .CS_P(CS_P)
    );

    // Inicialização dos sinais
    initial begin
        $init_signal_spy("dut/CLK_SYS", "CLK_SYS", 1);
        $init_signal_spy("dut/CLK_MUL", "CLK_MUL", 1);
        $init_signal_spy("dut/writeBack", "writeBack", 1);
		//$init_signal_spy("dut/dout", "conteudo_memoria_lida", 1);

        CLK = 0;
        Reset = 1;
        Data_BUS_READ = 32'hFFFFFFFF;
        Prog_BUS_READ = 32'h00000000;

        #10 Reset = 0;

        // Tempo adicional para observar o comportamento
        //#134003 $stop;
		#65000 $stop;
    end

    // Geração de clock com período de 10 unidades de tempo
    always #5 CLK = ~CLK;


	//always @(posedge CLK) begin
	//	if (WE == 0 && CS == 1) begin // leitura de memória
	//		$display("Time: %0t | Lendo ADDR: %h | Conteúdo: %h", $time, ADDR, conteudo_memoria_lida);
	//	end
	//end


endmodule
*/

/*
`timescale 1ns / 1ps

module cpu_TB();

    reg CLK, Reset;
    reg [31:0] Data_BUS_READ, Prog_BUS_READ;
	 reg CLK_SYS, CLK_MUL;
	 reg [31:0] writeBack;
	 //,fioA,fioB,dataOut_Mult;
	 // wire [31:0] monitor_dataOut_Inst_M;
    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog; 
	 //writeBack_out,monitor_outA,monitor_outB;
    wire CS, WE, CS_P;
	

    // Instância do módulo CPU
    cpu dut (
        .CLK(CLK),
        .Reset(Reset),
        .Data_BUS_READ(Data_BUS_READ),
        .Prog_BUS_READ(Prog_BUS_READ),
        .ADDR(ADDR),
        .Data_BUS_WRITE(Data_BUS_WRITE),
        .ADDR_Prog(ADDR_Prog),
        .CS(CS),
		  .WE(WE),
		  .CS_P(CS_P)
		     );

    // Inicialização dos sinais
    initial begin

		$init_signal_spy("dut/CLK_SYS","CLK_SYS",1);
		$init_signal_spy("dut/CLK_MUL","CLK_MUL",1);
		$init_signal_spy("dut/writeBack","writeBack",1);

				
	 CLK = 0;
        Reset = 1; // Ativando o reset inicialmente
        Data_BUS_READ = 32'hFFFFFFFF; // Inicializando com 0
        Prog_BUS_READ = 32'h0;
		  

        // Liberando o reset após 10 unidades de tempo
        #10 Reset = 0;


        // Tempo adicional para observar o comportamento
        #134003 $stop; // Finaliza a simulação após 134003 unidades de tempo
    end

    // Geração de clock com período de 10 unidades de tempo
    always #5 CLK = ~CLK;

    // Monitoramento dos sinais de depuração

endmodule
*/
