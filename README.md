# ELTD15A - Digital Systems Laboratory Project: Custom MIPS CPU

## Project Overview
This project implements a **custom MIPS CPU** in Verilog using a pipelined architecture with a 5-stage pipeline design. The CPU supports a subset of MIPS instructions and includes a custom shift-and-add multiplier for multiplication operations. The project was developed using Quartus Prime for synthesis and ModelSim-Altera for simulation, targeting the Intel Cyclone IV GX EP4CGX150DF31I7AD FPGA.

---

## Group Members
- **Gabriel Del Monte Schiavi Noda** - 2022014552  
  [GitHub Profile](https://github.com/GabrielDelMonte)
- **Gabrielle Gomes Almeida** - 2022002758  
  [GitHub Profile](https://github.com/gavgms12)
- **Leonardo José Siqueira Marinho** - 2022009730  
  [GitHub Profile](https://github.com/Lion4rdo)

---

## Architecture Overview

### Pipeline Stages
The CPU implements a 5-stage pipeline:
1. **Instruction Fetch (IF)** - Fetches instructions from memory
2. **Instruction Decode (ID)** - Decodes instructions and reads register file
3. **Execute (EX)** - Performs arithmetic/logic operations or address calculations
4. **Memory (MEM)** - Accesses data memory for load/store operations
5. **Write Back (WB)** - Writes results back to register file

### Key Performance Metrics
- **Latency**: 5 clock cycles
- **Throughput**: 32 bits / CLK_SYS
- **Maximum Frequency**: 
  - Multiplier: 306.18 MHz
  - System: 50.11 MHz
  - Operating Frequency: 12.24 MHz

---

## Project Structure

### Repository Organization
```text
CustomMIPS_CPU/
├── MIPS_CPU/
│   ├── cpu.v              // Top-level CPU module
│   ├── TB.v               // CPU testbench
│   ├── ALU/               // Arithmetic Logic Unit
│   ├── ADDRDecoding/      // Address decoding for data memory
│   ├── ADDRDecoding_Prog/ // Address decoding for program memory
│   ├── Control/           // Control unit
│   ├── DataMemory/        // Data memory
│   ├── Extend/            // Sign extension unit
│   ├── InstMem/           // Instruction memory
│   ├── Multiplicador/     // Shift-and-add multiplier
│   ├── MUX/               // Multiplexer modules
│   ├── PC/                // Program counter
│   ├── PLL/               // Phase-locked loop for clock generation
│   ├── Register/          // Pipeline registers
│   └── RegisterFile/      // Register file implementation
├── Hex/
│   ├── Code/
│   │   ├── Code.asm       // Assembly test program
│   │   └── Code.hex       // Compiled machine code
│   └── Data/
│       └── Data.hex       // Initial data memory contents
└── guides/
    └── Guide.pdf          // Project documentation
```

---

## Key Modules

### 1. CPU (Top Module)
- **Description**: Integrates all pipeline stages and control logic
- **Inputs**: 
  - `CLK`: System clock
  - `Reset`: System reset
  - `Data_BUS_READ[31:0]`: Data bus input from external memory
  - `Prog_BUS_READ[31:0]`: Program bus input from external memory
- **Outputs**: 
  - `ADDR[31:0]`: Data memory address
  - `ADDR_Prog[31:0]`: Program memory address
  - `Data_BUS_WRITE[31:0]`: Data bus output to external memory
  - `CS`: Chip select for data memory
  - `CS_P`: Chip select for program memory
  - `WE`: Write enable for data memory

### 2. ALU (Arithmetic Logic Unit)
- **Function**: Performs arithmetic and logical operations
- **Operations**:
  - `00`: Addition (A + B)
  - `01`: Subtraction (A - B)
  - `10`: Bitwise AND (A & B)
  - `11`: Bitwise OR (A | B)
- **Outputs**: 32-bit result and zero flag

### 3. Control Unit
- **Function**: Generates control signals for all pipeline stages
- **Inputs**: 32-bit instruction
- **Outputs**: 25-bit control word containing:
  - Register addresses (rs, rt, rd)
  - ALU control signals
  - Memory control signals
  - Branch and jump flags
  - Multiplexer select signals

### 4. Register File
- **Function**: Stores 32 general-purpose registers
- **Ports**: Dual-read, single-write
- **Width**: 32 bits per register

### 5. Multiplicador (Shift-and-Add Multiplier)
- **Function**: Performs 16-bit × 16-bit multiplication
- **Algorithm**: Shift-and-add method
- **Latency**: Multiple clock cycles
- **Integration**: Uses separate high-frequency clock (CLK_MUL)

### 6. Memory Subsystem
- **Instruction Memory**: Stores program instructions
- **Data Memory**: Stores program data
- **Address Decoding**: Separate decoders for instruction and data memory

---

## Supported Instructions

The CPU supports the following MIPS instruction subset:

### R-Type Instructions
- `ADD`: Addition
- `SUB`: Subtraction
- `AND`: Bitwise AND
- `OR`: Bitwise OR
- `MUL`: Multiplication (custom implementation)

### I-Type Instructions  
- `ADDI`: Add immediate
- `ORI`: OR immediate
- `LW`: Load word
- `SW`: Store word
- `BNE`: Branch if not equal

### J-Type Instructions
- `JMP`: Jump

---

## Clock Domain Management

The design uses a Phase-Locked Loop (PLL) to generate two clock domains:
- **CLK_SYS**: System clock for main pipeline (50.11 MHz max)
- **CLK_MUL**: High-frequency clock for multiplier (306.18 MHz max)

This dual-clock approach optimizes performance by allowing the multiplier to operate at higher frequencies while maintaining system stability.

---

## Test Program

The included test program (`Code.asm`) demonstrates:
1. **Data Hazard Handling**: Shows pipeline stalls and data forwarding
2. **Vector Processing**: Sums elements of a vector
3. **Multiplication**: Uses the custom multiplier unit
4. **Memory Operations**: Load/store instructions
5. **Control Flow**: Branch and jump instructions

### Test Scenarios
- Vector summation with data hazards
- Multiplication of sum by constant (0x00FF)
- Memory access patterns
- Branch prediction testing

---

## Synthesis and Simulation

### Quartus Prime Setup
1. **Create Project**: Use Quartus Prime with Intel Cyclone IV GX target
2. **Add Files**: Include all Verilog modules and memory initialization files
3. **Constraints**: Set timing constraints for dual-clock domains
4. **Compile**: Synthesize and check for timing violations

### ModelSim Simulation
1. **Testbench**: Use `TB.v` for comprehensive system testing
2. **Waveform Analysis**: Monitor pipeline registers and control signals
3. **Verification**: Validate instruction execution and memory operations

---

## Performance Analysis

### Pipeline Efficiency
- **Throughput**: 1 instruction per clock cycle (ideal)
- **Latency**: 5 clock cycles from fetch to writeback
- **Hazard Handling**: Stalls and forwarding implemented

### Resource Utilization
- **Logic Elements**: Optimized for FPGA implementation
- **Memory Blocks**: Efficient use of on-chip memory
- **Clock Resources**: Dual-domain clocking with PLL

### Design Trade-offs
- **Multiplier**: Sequential implementation saves area but increases latency
- **Pipeline Depth**: 5 stages balance performance and complexity
- **Memory Architecture**: Separate instruction/data memories (Harvard architecture)

---

## Future Improvements

### Suggested Enhancements
1. **Pipeline Optimization**: Implement forwarding to reduce stalls
2. **Multiplier Upgrade**: Consider pipelined or parallel multiplier
3. **Instruction Set**: Add more MIPS instructions
4. **Branch Prediction**: Implement branch prediction logic
5. **Cache Memory**: Add instruction and data caches

### Performance Optimizations
- **Frequency Scaling**: Optimize timing for higher clock frequencies
- **Pipeline Balancing**: Reduce critical path delays
- **Resource Sharing**: Optimize area utilization

---

## References
- [**Guide.pdf**](guides/Guide.pdf): Complete project documentation and requirements
- MIPS Architecture Reference Manual
- Intel Cyclone IV FPGA Documentation
- Quartus Prime User Guide

---

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
