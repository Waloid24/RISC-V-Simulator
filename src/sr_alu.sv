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

module sr_alu
(
    input        [31:0] srcA,
    input        [31:0] srcB,
    input        [ 2:0] oper,
    output              zero,
    output logic [31:0] result,
    output logic        ov
);

    logic [2:0] sa;
    always_comb
        case (oper)
            default   : result =  srcA +  srcB;
            `ALU_ADD  : result =  srcA +  srcB;
            `ALU_OR   : result =  srcA |  srcB;
            `ALU_SRL  : result =  srcA >> srcB [4:0];
            `ALU_SLTU : result = (srcA <  srcB) ? 32'd1 : 32'd0;
            `ALU_SUB  : result =  srcA -  srcB;
            `ALU_KSLL8: begin
              logic [7:0] res [3:0];
              logic [15:0] debug_temp;
              logic [15:0] temp;
              sa = srcB[2:0];
              if (sa != 0) begin
                for (int i = 0; i < 4; i++) begin
                  temp[7:0] = srcA[8*i +: 8];
                  temp[15:8] = {8{temp[7]}};
                  // temp_debug[(7+sa):0] = temp << sa;
                  //debug_temp = $signed(temp);
                  temp = temp << sa;
                  if ($signed(temp) > 0 && $signed(temp) > $signed(16'h007F)) begin
                    res[i] = 8'h7F;
                    ov = 1'b1;
                  end else if ($signed(temp) < 0 && $signed(temp) < $signed(16'hFF80)) begin
                    res[i] = 8'h80;
                    ov = 1'b1;
                  end else begin
                    res[i] = temp[7:0];
                  end
                end
                result = {res[3], res[2], res[1], res[0]};
              end else begin
                result = srcA;
              end
            end
        endcase

    assign zero = (result == '0);

endmodule
