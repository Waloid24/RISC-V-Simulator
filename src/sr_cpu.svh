//
//  schoolRISCV - small RISC-V CPU
//
//  Originally based on Sarah L. Harris MIPS CPU
//  & schoolMIPS project.
//
//  Copyright (c) 2017-2020 Stanislav Zhelnio & Aleksandr Romanov.
//
//  Modified in 2024 by Yuri Panchul & Mike Kuskov
//  for systemverilog-homework project.
//

`ifndef SR_CPU_SVH
`define SR_CPU_SVH

// ALU commands

`define ALU_ADD     4'b0000
`define ALU_OR      4'b0001
`define ALU_SRL     4'b0010
`define ALU_SLTU    4'b0011
`define ALU_SUB     4'b0100
`define ALU_KSLL8   4'b0101
`define ALU_KSLLI8  4'b0110
`define ALU_KSLRA8  4'b0111
`define ALU_KSLRAW  4'b1000

// Instruction opcode

`define RVOP_ADDI    7'b0010011
`define RVOP_BEQ     7'b1100011
`define RVOP_LUI     7'b0110111
`define RVOP_BNE     7'b1100011
`define RVOP_ADD     7'b0110011
`define RVOP_OR      7'b0110011
`define RVOP_SRL     7'b0110011
`define RVOP_SLTU    7'b0110011
`define RVOP_SUB     7'b0110011
`define RVOP_KSLL8   7'b1110111
`define RVOP_KSLLI8  7'b1110111
`define RVOP_KSLRA8  7'b1110111
`define RVOP_KSLRA8U 7'b1110111
`define RVOP_KSLRAW  7'b1110111

// Instruction funct3

`define RVF3_ADDI    3'b000
`define RVF3_BEQ     3'b000
`define RVF3_BNE     3'b001
`define RVF3_ADD     3'b000
`define RVF3_OR      3'b110
`define RVF3_SRL     3'b101
`define RVF3_SLTU    3'b011
`define RVF3_SUB     3'b000
`define RVF3_KSLL8   3'b000
`define RVF3_KSLLI8  3'b000
`define RVF3_KSLRA8  3'b000
`define RVF3_KSLRA8U 3'b000
`define RVF3_KSLRAW  3'b001
`define RVF3_ANY     3'b???

// Instruction funct7

`define RVF7_ADD     7'b0000000
`define RVF7_OR      7'b0000000
`define RVF7_SRL     7'b0000000
`define RVF7_SLTU    7'b0000000
`define RVF7_SUB     7'b0100000
`define RVF7_KSLL8   7'b0110110
`define RVF7_KSLLI8  7'b0111110
`define RVF7_KSLRA8  7'b0101111
`define RVF7_KSLRA8U 7'b0110111
`define RVF7_KSLRAW  7'b0110111
`define RVF7_ANY     7'b???????

`endif  // `ifndef SR_CPU_SVH
