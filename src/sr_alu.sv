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
    input        [ 3:0] oper,
    input               rounding,
    output              zero,
    output logic [31:0] result,
    output logic        ov
);

    logic [2:0] sa;
    logic [3:0] shift_val;
    logic signed [5:0] shift_amount_6;
    logic [5:0] sa_6;
    logic [5:0] sa_temp_6;
    logic [63:0] tmp_64;
    logic signed [63:0] tmp_signed_64;

    logic [3:0] pos_shift;
    logic [7:0] signed_res;
    logic signed [7:0] round_add;
    logic signed [7:0] rounded;
    always_comb
        case (oper)
            default   : result =  srcA +  srcB;
            `ALU_ADD  : result =  srcA +  srcB;
            `ALU_OR   : result =  srcA |  srcB;
            `ALU_SRL  : result =  srcA >> srcB [4:0];
            `ALU_SLTU : result = (srcA <  srcB) ? 32'd1 : 32'd0;
            `ALU_SUB  : result =  srcA -  srcB;
            `ALU_KSLL8, `ALU_KSLLI8: begin
              logic [7:0] res [3:0];
              logic [15:0] temp;
              logic original_msb;
              sa = srcB[2:0];
              ov = 1'b0;
              if (sa != 0) begin
                for (int i = 0; i < 4; i++) begin
                  temp[7:0] = srcA[8*i +: 8];
                  original_msb = temp[7];
                  temp[15:8] = {8{temp[7]}};
                  temp = temp << sa;
                  if (original_msb == 1'b1) begin
                    temp[7] = 1'b1;
                  end
                  if ($signed(temp) > 0 && $signed(temp) > $signed(16'h007F)) begin
                    res[i] = 8'h7F;
                    ov = 1'b1;
                  end else if ($signed(temp) < 0 && $signed(temp) < $signed(16'hFF80)) begin
                    res[i] = 8'h80;
                    ov = 1'b1;
                  end else begin
                    res[i] = temp[7:0];
                    ov = 1'b0;
                  end
                end
                result = {res[3], res[2], res[1], res[0]};
              end else begin
                result = srcA;
              end
            end
            `ALU_KSLRA8: begin
              logic [7:0] res [3:0];
              logic [15:0] temp;
              logic original_msb;
              shift_val = srcB[3:0];

              if (shift_val != 0) begin
                for (int i = 0; i < 4; i++) begin
                  temp[7:0] = srcA[8*i +: 8];
                  if ($signed(shift_val) > 0) begin
                    original_msb = temp[7];
                    temp[15:8] = {8{temp[7]}};
                    temp = temp << shift_val;
                    if (original_msb == 1'b1) begin
                      temp[7] = 1'b1;
                    end
                    if ($signed(temp) > $signed(16'h007F)) begin
                      res[i] = 8'h7F;
                      ov = 1'b1;
                    end else if ($signed(temp) < $signed(16'hFF80)) begin
                      res[i] = 8'h80;
                      ov = 1'b1;
                    end else begin
                      res[i] = temp[7:0];
                      ov = 1'b0;
                    end
                  end else if ($signed(shift_val) < 0) begin
                    pos_shift = -shift_val;
                    signed_res = $signed(temp);
                    if (rounding) begin
                      round_add = (1 << (pos_shift-1));
                      rounded = signed_res + round_add;
                      res[i] = rounded >>> pos_shift;
                    end else begin
                      res[i] = signed_res >>> pos_shift;
                    end
                  end
                end
                result = {res[3], res[2], res[1], res[0]};
              end else begin
                result = srcA;
              end
            end
            `ALU_KSLRAW: begin
              logic original_msb;
              shift_amount_6 = srcB[5:0];
              if (shift_amount_6 != 0) begin
                if (shift_amount_6 < 0) begin
                  sa_temp_6 = -shift_amount_6;
                  sa_6 = (sa_temp_6 > 31) ? 31 : sa_temp_6;
                  result = $signed(srcA) >>> sa_6;
                  ov = 0;
                end else begin
                  original_msb = srcA[31];
                  sa_6 = shift_amount_6;
                  tmp_64[31:0] = srcA[31:0];
                  tmp_64[63:32] = {32{srcA[31]}};
                  tmp_64 = tmp_64 << sa_6;
                  if (original_msb == 1'b1) begin
                    tmp_64[31] = original_msb;
                  end
                  if ($signed(tmp_64) > 32'sh7fffffff) begin
                    result = 32'h7fffffff;
                    ov = 1'b1;
                  end else if ($signed(tmp_64) < 32'sh80000000) begin
                    result = 32'h80000000;
                    ov = 1'b1;
                  end else begin
                    result = tmp_64[31:0];
                    ov = 1'b0;
                  end
                end
              end else begin
                result = srcA;
              end
            end
        endcase

    assign zero = (result == '0);

endmodule
