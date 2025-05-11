#!/bin/bash

# run_linux_mac.sh
# Script to compile and simulate the RISC-V processor with KSLL8 testbench
# Compatible with Linux and macOS
# Assumes Icarus Verilog is installed

set -e

SRC_DIR="../src"
TEST_DIR="./"
OUT_DIR="./"

# Output files
SIM_EXEC="$OUT_DIR/sim"
VCD_FILE="$OUT_DIR/dump.vcd"

echo "Cleaning previous outputs..."
rm -f "$SIM_EXEC" "$VCD_FILE"

echo "Compiling SystemVerilog files..."
iverilog -g2012 -o "$SIM_EXEC" \
    -I "$SRC_DIR" \
    "$SRC_DIR/instruction_rom.sv" \
    "$SRC_DIR/sr_alu.sv" \
    "$SRC_DIR/sr_cpu.sv" \
    "$SRC_DIR/sr_decode.sv" \
    "$SRC_DIR/register_with_rst.sv" \
    "$SRC_DIR/sr_control.sv" \
    "$SRC_DIR/sr_register_file.sv" \
    "$TEST_DIR/tb.sv"

if [ $? -eq 0 ]; then
    echo "Compilation successful."
else
    echo "Error: Compilation failed."
    exit 1
fi

echo "Running simulation..."
vvp "$SIM_EXEC"

echo "Done."
