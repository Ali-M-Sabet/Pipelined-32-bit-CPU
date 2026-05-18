onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FLAGS -color Orange -label C_Flag /ta_one_operand_tb/uut/u_EX2/ccr_str(2)
add wave -noupdate -expand -group FLAGS -color Orange -label N_Flag /ta_one_operand_tb/uut/u_EX2/ccr_str(1)
add wave -noupdate -expand -group FLAGS -color Orange -label Z_Flag /ta_one_operand_tb/uut/u_EX2/ccr_str(0)
add wave -noupdate -expand -group FLAGS -color Orange -label CCR -radix binary /ta_one_operand_tb/uut/u_EX2/ccr_str
add wave -noupdate -expand -group FLAGS -color Orange -label Saved_CCR -radix binary /ta_one_operand_tb/uut/u_EX2/bccr_str
add wave -noupdate -expand -group STACK_POINTER -color Brown -label SP -radix hexadecimal /ta_one_operand_tb/uut/u_MEM/SP
add wave -noupdate -expand -group STACK_POINTER -color Brown -label New_SP -radix hexadecimal /ta_one_operand_tb/uut/u_MEM/newSP
add wave -noupdate -expand -group { CLOCK} -color Cyan /ta_one_operand_tb/clk
add wave -noupdate -expand -group { REGISTERS} -color Magenta -radix hexadecimal -childformat {{/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(0) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(1) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(2) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(3) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(4) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(5) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(6) -radix hexadecimal} {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(7) -radix hexadecimal}} -expand -subitemconfig {/ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(0) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(1) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(2) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(3) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(4) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(5) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(6) {-color Magenta -radix hexadecimal} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers(7) {-color Magenta -radix hexadecimal}} /ta_one_operand_tb/uut/u_decode_stage/u_reg_file/registers
add wave -noupdate -expand -group {  CONTROL & RESET} -color Pink /ta_one_operand_tb/rst
add wave -noupdate -expand -group {  CONTROL & RESET} -color Pink /ta_one_operand_tb/core_enable
add wave -noupdate -expand -group { I/O PORTS} -color Blue -radix hexadecimal /ta_one_operand_tb/input_port
add wave -noupdate -expand -group { I/O PORTS} -color Blue -radix hexadecimal /ta_one_operand_tb/output_port
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_one_operand_tb/uut/u_IFID/inst_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/clk
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/flush
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/write_en
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/alu_res
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/rsrc1
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/mem_data_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/imm
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_dst_addr
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/input_port
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/alu_op
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_data
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_WE
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/ret
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/SW_INTDone
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/is_load
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/out_enable
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/HLT
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/alu_res_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/rsrc1_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/mem_data_out_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/imm_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_dst_addr_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/input_port_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/alu_op_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_data_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_WE_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/ret_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/SW_INTDone_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/is_load_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/out_enable_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/HLT_out
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/alu_res_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/rsrc1_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/mem_data_out_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/imm_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_dst_addr_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/input_port_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/alu_op_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_data_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/reg_WE_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/ret_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/SW_INTDone_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/is_load_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/out_enable_str
add wave -noupdate -expand -group { CCR} -color Navy -radix hexadecimal /ta_one_operand_tb/uut/u_MEMWB/HLT_str
add wave -noupdate -expand -group { CCR} -group { PC & FETCH} -color Yellow -radix hexadecimal /ta_one_operand_tb/fetch_pc_debug
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {119 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {293 ns}
