module control(
	input [31:0]input_data,
	output [24:0]output_data
);

	// Grupo 22

	reg [5:0]operation_code;
	reg [5:0]operation;
	reg jmpAddress;

	//

	reg [4:0]rs;
	reg [4:0]rt;
	reg [4:0]rd;
	reg WR_regfile;
	reg mux_immediate_or_regB;
	reg [1:0]ALU_sel;
	reg mul_Start;
	reg mux2_ALU;
	reg WR_mem;
	reg CS_WB_2;
	reg branchFlag;
	reg jmpFlag;
	
	assign output_data = {
		rs,
		rt,
		rd,
		WR_regfile,
		mux_immediate_or_regB,
		ALU_sel,
		mul_Start,
		mux2_ALU,
		WR_mem,
		CS_WB_2,
		branchFlag,
		jmpFlag
	};

	always @(input_data) begin

		operation_code = input_data[31:26];
		rs = input_data[25:21];
		rt = input_data[20:16];

		operation = input_data[5:0];

		case(operation_code)
			6'd2: begin // JMP
				rd = 5'b0;
				WR_regfile = 0;
				mux_immediate_or_regB = 0;
				ALU_sel = 2'b00;
				mul_Start = 0;
				mux2_ALU = 1;
				WR_mem = 0;
				CS_WB_2 = 0;
				branchFlag = 0;
				jmpFlag = 1;
			end
			6'd54: begin // LW
				rd = rt;
				WR_regfile = 1;
				mux_immediate_or_regB = 1;
				ALU_sel = 2'b00;
				mul_Start = 0;
				mux2_ALU = 1;
				WR_mem = 0;
				CS_WB_2 = 0;
				branchFlag = 0;
				jmpFlag = 0;
			end
			6'd55: begin // SW
				rd = rs;
				WR_regfile = 0;
				mux_immediate_or_regB = 1;
				ALU_sel = 2'b00;
				mul_Start = 0;
				mux2_ALU = 1;
				WR_mem = 1;
				CS_WB_2 = 0;
				branchFlag = 0;
				jmpFlag = 0;
			end
			6'd56: begin // BNE
				rd = 5'b0;
				WR_regfile = 0;
				mux_immediate_or_regB = 0;
				ALU_sel = 2'b01;
				mul_Start = 0;
				mux2_ALU = 1;
				WR_mem = 0;
				CS_WB_2 = 0;
				branchFlag = 1;
				jmpFlag = 0;
			end
			6'd57: begin // ADDI
				rd = rt;
				WR_regfile = 1;
				mux_immediate_or_regB = 1;
				ALU_sel = 2'b00;
				mul_Start = 0;
				mux2_ALU = 1;
				WR_mem = 0;
				CS_WB_2 = 1;
				branchFlag = 0;
				jmpFlag = 0;
			end
			6'd58: begin // ORI
				rd = rt;
				WR_regfile = 1;
				mux_immediate_or_regB = 1;
				ALU_sel = 2'b11;
				mul_Start = 0;
				mux2_ALU = 1;
				WR_mem = 0;
				CS_WB_2 = 1;
				branchFlag = 0;
				jmpFlag = 0;
			end
			default: begin
				rd = input_data[15:11];
				case (operation)
					6'd32: begin // ADD
						rd = rd;
						WR_regfile = 1;
						mux_immediate_or_regB = 0;
						ALU_sel = 2'b00;
						mul_Start = 0;
						mux2_ALU = 1;
						WR_mem = 0;
						CS_WB_2 = 1;
						branchFlag = 0;
						jmpFlag = 0;
					end
					6'd34: begin // SUB
						rd = rd;
						WR_regfile = 1;
						mux_immediate_or_regB = 0;
						ALU_sel = 2'b01;
						mul_Start = 0;
						mux2_ALU = 1;
						WR_mem = 0;
						CS_WB_2 = 0;
						branchFlag = 0;
						jmpFlag = 0;
					end
					6'd50: begin // MUL
						rd = rd;
						WR_regfile = 1;
						mux_immediate_or_regB = 0;
						ALU_sel = 2'b00;
						mul_Start = 1;
						mux2_ALU = 0;
						WR_mem = 0;
						CS_WB_2 = 1;
						branchFlag = 0;
						jmpFlag = 0;
					end
					6'd36: begin // AND
						rd = rd;
						WR_regfile = 1;
						mux_immediate_or_regB = 0;
						ALU_sel = 2'b10;
						mul_Start = 1;
						mux2_ALU = 0;
						WR_mem = 0;
						CS_WB_2 = 0;
						branchFlag = 0;
						jmpFlag = 0;
					end
					6'd37: begin // OR
						rd = rd;
						WR_regfile = 1;
						mux_immediate_or_regB = 0;
						ALU_sel = 2'b11;
						mul_Start = 1;
						mux2_ALU = 0;
						WR_mem = 0;
						CS_WB_2 = 0;
						branchFlag = 0;
						jmpFlag = 0;
					end
					default: begin
						rs = 5'b0;
						rt = 5'b0;
						rd = 5'b0;
						WR_regfile = 0;
						mux_immediate_or_regB = 0;
						ALU_sel = 2'b00;
						mul_Start = 0;
						mux2_ALU = 0;
						WR_mem = 0;
						CS_WB_2 = 0;
						branchFlag = 0;
						jmpFlag = 0;
					end
				endcase			
			end
		endcase
	end

endmodule
