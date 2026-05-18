# ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ModelSim Script: Two-Operand Instruction Test
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# This simulation tests two-operand instruction encoding and execution

onerror {quit -code 1}
exec python assembler/assembler.py TwoOperand.txt -o program.mem --input-output input.mem --bin --bin-output TwoOperand.bin
if {![file exists work]} {
    vlib work
}
vcom -2008 "src/1.Components/alu.vhd"
vcom -2008 "src/1.Components/conditional_jump_decoder.vhd"
vcom -2008 "src/1.Components/forwarding_unit.vhd"
vcom -2008 "src/1.Components/incrementer.vhd"
vcom -2008 "src/1.Components/intrupt_handler.vhd"
vcom -2008 "src/1.Components/memory_file.vhd"
vcom -2008 "src/1.Components/register_file.vhd"
vcom -2008 "src/1.Components/sign_extend.vhd"
vcom -2008 "src/1.Components/zero_extend.vhd"
vcom -2008 "src/4.Controlling/Control_unit.vhd"
vcom -2008 "src/4.Controlling/hazard_unit.vhd"
vcom -2008 "src/4.Controlling/predictor_2_bit.vhd"
vcom -2008 "src/2.PIPLINE REGISTERS/IF_ID.vhd"
vcom -2008 "src/2.PIPLINE REGISTERS/ID_EX1.vhd"
vcom -2008 "src/2.PIPLINE REGISTERS/EX1_EX2.vhd"
vcom -2008 "src/2.PIPLINE REGISTERS/EX2_MEM.vhd"
vcom -2008 "src/2.PIPLINE REGISTERS/MEM_WB.vhd"
vcom -2008 "src/3.Stages/FETCH.vhd"
vcom -2008 "src/3.Stages/DECODE.vhd"
vcom -2008 "src/3.Stages/EX1.vhd"
vcom -2008 "src/3.Stages/EX2.vhd"
vcom -2008 "src/3.Stages/MEMORY.vhd"
vcom -2008 "src/3.Stages/WB.vhd"
vcom -2008 "src/5.TOP/top_level.vhd"
vcom -2008 "src/TestBench/Component TB/two_operand_tb.vhd"
vsim -voptargs=+acc work.ta_two_operand_tb
delete wave *
do "src/TestBench/do_files/add_core_debug_waves.do"
add wave -group " CLOCK" -color Cyan sim:/ta_two_operand_tb/clk
add wave -group "  CONTROL & RESET" -color Pink sim:/ta_two_operand_tb/rst
add wave -group "  CONTROL & RESET" -color Pink sim:/ta_two_operand_tb/core_enable
add wave -group " I/O PORTS" -color Blue -radix hex sim:/ta_two_operand_tb/input_port
add wave -group " I/O PORTS" -color Blue -radix hex sim:/ta_two_operand_tb/output_port
add wave -group " PC & FETCH" -color Yellow -radix hex sim:/ta_two_operand_tb/fetch_pc_debug
add wave -group " REGISTERS" -color Magenta -radix hex sim:/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers
add wave -group " PIPELINE" -color Green -radix hex sim:/ta_two_operand_tb/uut/u_IFID/inst_out
add wave -group " PIPELINE" -color Green -radix hex sim:/ta_two_operand_tb/uut/u_EX1/*
add wave -group " PIPELINE" -color Green -radix hex sim:/ta_two_operand_tb/uut/u_EX2/*
add wave -group " CCR" -color Navy -radix hex sim:/ta_two_operand_tb/uut/u_MEMWB/*
run 3 us
puts "═══════════════════════════════════════════════════════════════════════════"
puts "Two-Operand Instruction Test completed successfully."
puts "═══════════════════════════════════════════════════════════════════════════"
