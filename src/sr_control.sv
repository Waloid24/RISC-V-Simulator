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

`include "sr_cpu.svh"

module sr_control
(
    input        [ 6:0] cmdOp,
    input        [ 2:0] cmdF3,
    input        [ 6:0] cmdF7,
    input               aluZero,
    output              pcSrc,
    output logic        regWrite,
    output logic        aluSrc,
    output logic        wdSrc,
    output logic [ 3:0] aluControl,
    output logic        aluRounding
);
    logic          branch;
    logic          condZero;
    assign pcSrc = branch & (aluZero == condZero);

    always_comb
    begin
        branch      = 1'b0;
        condZero    = 1'b0;
        regWrite    = 1'b0;
        aluSrc      = 1'b0;
        wdSrc       = 1'b0;
        aluRounding = 1'b0;
        aluControl  = `ALU_ADD;

        casez ({ cmdF7, cmdF3, cmdOp })
            { `RVF7_ADD,     `RVF3_ADD,     `RVOP_ADD     } : begin regWrite = 1'b1; aluControl = `ALU_ADD;    end
            { `RVF7_OR,      `RVF3_OR,      `RVOP_OR      } : begin regWrite = 1'b1; aluControl = `ALU_OR;     end
            { `RVF7_SRL,     `RVF3_SRL,     `RVOP_SRL     } : begin regWrite = 1'b1; aluControl = `ALU_SRL;    end
            { `RVF7_SLTU,    `RVF3_SLTU,    `RVOP_SLTU    } : begin regWrite = 1'b1; aluControl = `ALU_SLTU;   end
            { `RVF7_SUB,     `RVF3_SUB,     `RVOP_SUB     } : begin regWrite = 1'b1; aluControl = `ALU_SUB;    end
            { `RVF7_KSLL8,   `RVF3_KSLL8,   `RVOP_KSLL8   } : begin regWrite = 1'b1; aluControl = `ALU_KSLL8;  end
            { `RVF7_KSLRA8,  `RVF3_KSLRA8,  `RVOP_KSLRA8  } : begin regWrite = 1'b1; aluControl = `ALU_KSLRA8; end
            { `RVF7_KSLRAW,  `RVF3_KSLRAW,  `RVOP_KSLRAW  } : begin regWrite = 1'b1; aluControl = `ALU_KSLRAW; end
            { `RVF7_KSLRA8U, `RVF3_KSLRA8U, `RVOP_KSLRA8U } : begin regWrite = 1'b1; aluRounding = 1'b1; aluControl = `ALU_KSLRA8; end

            { `RVF7_KSLLI8, `RVF3_KSLLI8, `RVOP_KSLLI8 } : begin regWrite = 1'b1; aluSrc = 1'b1; aluControl = `ALU_KSLLI8; end
            { `RVF7_ANY,    `RVF3_ADDI,   `RVOP_ADDI   } : begin regWrite = 1'b1; aluSrc = 1'b1; aluControl = `ALU_ADD;    end

            { `RVF7_ANY,    `RVF3_ANY,    `RVOP_LUI    } : begin regWrite = 1'b1; wdSrc  = 1'b1; end

            { `RVF7_ANY,  `RVF3_BEQ,  `RVOP_BEQ  } : begin branch = 1'b1; condZero = 1'b1; aluControl = `ALU_SUB; end
            { `RVF7_ANY,  `RVF3_BNE,  `RVOP_BNE  } : begin branch = 1'b1; aluControl = `ALU_SUB; end
        endcase
    end

endmodule
