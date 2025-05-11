module tb;

    logic        clk;
    logic        rst;

    wire  [31:0] imAddr;
    wire  [31:0] imData;

    logic [ 4:0] regAddr;
    wire  [31:0] regData;

    localparam ROM_SIZE = 1024;
    localparam ADDR_W   = $clog2(ROM_SIZE);

    integer test_num;
    reg [31:0] expected_results [0:3];
    reg expected_ov [0:3];

    sr_cpu cpu
    (
        .clk     ( clk     ),
        .rst     ( rst     ),
        .imAddr  ( imAddr  ),
        .imData  ( imData  ),
        .regAddr ( regAddr ),
        .regData ( regData )
    );

    instruction_rom # (.SIZE (ROM_SIZE)) i_rom
    (
        .a       ( ADDR_W' (imAddr) ),
        .rd      ( imData           )
    );

    initial
    begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial
    begin
        rst <= 1'bx;
        repeat (2) @ (posedge clk);
        rst <= 1'b1;
        repeat (2) @ (posedge clk);
        rst <= 1'b0;
    end

    initial
    begin
        `ifdef __ICARUS__
            $dumpvars;
        `endif

        test_num = 0;

        expected_results[0] = 32'h7F7F7F7F;
        expected_results[1] = 32'h40404040;
        expected_results[2] = 32'h80808080;
        expected_results[3] = 32'hA0A0A0A0;

        expected_ov[0] = 1'b1;
        expected_ov[1] = 1'b0;
        expected_ov[2] = 1'b1;
        expected_ov[3] = 1'b0;

        regAddr <= 5'd10;  // x10

        @ (negedge rst);

        repeat (1000)
        begin
            @ (posedge clk);

            if (regAddr == 5'd10 && regData == expected_results[test_num]) begin
                $display("Test %0d: x10 result PASS (expected %h, got %h)", test_num+1, expected_results[test_num], regData);
                
                // Switch to check OV bit
                regAddr <= 5'd31;
                @ (posedge clk);
                
                if (regData[0] == expected_ov[test_num]) begin
                    $display("Test %0d: OV bit PASS (expected %b, got %b)", test_num+1, expected_ov[test_num], regData[0]);
                    test_num = test_num + 1;
                    if (test_num == 4) begin
                        $display("%s PASS: All KSLL8 tests passed", `__FILE__);
                        $finish;
                    end
                end else begin
                    $display("%s FAIL: Test %0d OV bit mismatch (expected %b, got %b)", `__FILE__, test_num+1, expected_ov[test_num], regData[0]);
                    $finish;
                end
                
                // Switch back to x10
                regAddr <= 5'd10;
            end
        end

        $display("%s FAIL: Timeout, not all tests completed", `__FILE__);
        $finish;
    end

    int unsigned cycle = 0;
    bit wasRst = 1'b0;

    logic [31:0] prevImAddr;
    logic [31:0] prevRegData;

    always @ (posedge clk)
    begin
        $write ("cycle %5d", cycle);
        cycle <= cycle + 1'b1;

        if (rst)
        begin
            $write (" rst");
            wasRst <= 1'b1;
        end
        else
        begin
            $write ("    ");
        end

        if (imAddr !== prevImAddr)
            $write (" %h", imAddr);
        else
            $write ("         ");

        if (wasRst & ~rst & $isunknown (imData))
        begin
            $display ("%s FAIL: fetched instruction at address %x contains Xs: %x",
                `__FILE__, imAddr, imData);
            $finish;
        end

        if (regData !== prevRegData)
            $write (" %h", regData);
        else
            $write ("         ");

        prevImAddr  <= imAddr;
        prevRegData <= regData;

        $display;
    end

endmodule
