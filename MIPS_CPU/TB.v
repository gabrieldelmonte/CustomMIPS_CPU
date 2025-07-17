`timescale 1ns / 1ps

module TB();

    reg CLK, Reset;
    reg [31:0]Data_BUS_READ, Prog_BUS_READ;
    reg CLK_SYS, CLK_MUL;
    reg [31:0]writeBack;

    wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog;
    wire CS, WE, CS_P;

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
        $init_signal_spy("dut/CLK_SYS", "CLK_SYS", 1);
        $init_signal_spy("dut/CLK_MUL", "CLK_MUL", 1);
        $init_signal_spy("dut/writeBack", "writeBack", 1);

        CLK = 0;
        Reset = 1;
        Data_BUS_READ = 32'hFFFFFFFF;
        Prog_BUS_READ = 32'h00000000;

        #10 Reset = 0;

		#67500 $stop;
    end

	always #10 CLK = ~CLK;

    always @(posedge CLK) begin
        $display("-------------------------------------------------------------------------------");
        $display("Time: %0t", $time);
        $display("ADDR = %h | WE = %b | CS = %b | Data_BUS_WRITE = %h", ADDR, WE, CS, Data_BUS_WRITE);
        $display("ADDR_Prog = %h | CS_P = %b", ADDR_Prog, CS_P);
        $display("-------------------------------------------------------------------------------");
    end

endmodule
