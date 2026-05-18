onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FLAGS -color Orange -label C_Flag /ta_branch_tb/uut/u_EX2/ccr_str(2)
add wave -noupdate -expand -group FLAGS -color Orange -label N_Flag /ta_branch_tb/uut/u_EX2/ccr_str(1)
add wave -noupdate -expand -group FLAGS -color Orange -label Z_Flag /ta_branch_tb/uut/u_EX2/ccr_str(0)
add wave -noupdate -expand -group FLAGS -color Orange -label CCR -radix binary /ta_branch_tb/uut/u_EX2/ccr_str
add wave -noupdate -expand -group FLAGS -color Orange -label Saved_CCR -radix binary /ta_branch_tb/uut/u_EX2/bccr_str
add wave -noupdate -expand -group STACK_POINTER -color Brown -label SP -radix hexadecimal /ta_branch_tb/uut/u_MEM/SP
add wave -noupdate -expand -group STACK_POINTER -color Brown -label New_SP -radix hexadecimal /ta_branch_tb/uut/u_MEM/newSP
add wave -noupdate -expand -group { CLOCK} -color Cyan /ta_branch_tb/clk
add wave -noupdate -expand -group { CONTROL & RESET} -color Pink /ta_branch_tb/rst
add wave -noupdate -expand -group { CONTROL & RESET} -color Pink /ta_branch_tb/interrupt
add wave -noupdate -expand -group { CONTROL & RESET} -color Pink /ta_branch_tb/core_enable
add wave -noupdate -group { I/O PORTS} -color Blue -radix hexadecimal -childformat {{/ta_branch_tb/input_port(31) -radix hexadecimal} {/ta_branch_tb/input_port(30) -radix hexadecimal} {/ta_branch_tb/input_port(29) -radix hexadecimal} {/ta_branch_tb/input_port(28) -radix hexadecimal} {/ta_branch_tb/input_port(27) -radix hexadecimal} {/ta_branch_tb/input_port(26) -radix hexadecimal} {/ta_branch_tb/input_port(25) -radix hexadecimal} {/ta_branch_tb/input_port(24) -radix hexadecimal} {/ta_branch_tb/input_port(23) -radix hexadecimal} {/ta_branch_tb/input_port(22) -radix hexadecimal} {/ta_branch_tb/input_port(21) -radix hexadecimal} {/ta_branch_tb/input_port(20) -radix hexadecimal} {/ta_branch_tb/input_port(19) -radix hexadecimal} {/ta_branch_tb/input_port(18) -radix hexadecimal} {/ta_branch_tb/input_port(17) -radix hexadecimal} {/ta_branch_tb/input_port(16) -radix hexadecimal} {/ta_branch_tb/input_port(15) -radix hexadecimal} {/ta_branch_tb/input_port(14) -radix hexadecimal} {/ta_branch_tb/input_port(13) -radix hexadecimal} {/ta_branch_tb/input_port(12) -radix hexadecimal} {/ta_branch_tb/input_port(11) -radix hexadecimal} {/ta_branch_tb/input_port(10) -radix hexadecimal} {/ta_branch_tb/input_port(9) -radix hexadecimal} {/ta_branch_tb/input_port(8) -radix hexadecimal} {/ta_branch_tb/input_port(7) -radix hexadecimal} {/ta_branch_tb/input_port(6) -radix hexadecimal} {/ta_branch_tb/input_port(5) -radix hexadecimal} {/ta_branch_tb/input_port(4) -radix hexadecimal} {/ta_branch_tb/input_port(3) -radix hexadecimal} {/ta_branch_tb/input_port(2) -radix hexadecimal} {/ta_branch_tb/input_port(1) -radix hexadecimal} {/ta_branch_tb/input_port(0) -radix hexadecimal}} -subitemconfig {/ta_branch_tb/input_port(31) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(30) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(29) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(28) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(27) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(26) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(25) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(24) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(23) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(22) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(21) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(20) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(19) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(18) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(17) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(16) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(15) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(14) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(13) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(12) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(11) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(10) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(9) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(8) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(7) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(6) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(5) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(4) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(3) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(2) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(1) {-color Blue -radix hexadecimal} /ta_branch_tb/input_port(0) {-color Blue -radix hexadecimal}} /ta_branch_tb/input_port
add wave -noupdate -group { I/O PORTS} -color Blue -radix hexadecimal /ta_branch_tb/output_port
add wave -noupdate -group { REGISTERS} -color Magenta -radix hexadecimal -childformat {{/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(0) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(1) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(2) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(3) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(4) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(5) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(6) -radix hexadecimal} {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(7) -radix hexadecimal}} -expand -subitemconfig {/ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(0) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(1) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(2) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(3) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(4) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(5) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(6) {-color Magenta -radix hexadecimal} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers(7) {-color Magenta -radix hexadecimal}} /ta_branch_tb/uut/u_decode_stage/u_reg_file/registers
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IFID/inst_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/clk
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/flush
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/write_en
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/predicted_T
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/HW_INT_ret
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/pc
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/imm
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_dst_addr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc1_addr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc2_addr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/input_port
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/alu_src
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/alu_op
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/ccr_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/modify_ccr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/branch_op
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/newSP_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/SP_WE
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/add_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_addr_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_data_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_WE
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_R
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_data
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_WE
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/ret
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/INT_state
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/is_load
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/swap_state
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/out_enable
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/HLT
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/predicted_T_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/HW_INT_ret_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/pc_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc1_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc2_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/imm_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_dst_addr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc1_addr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc2_addr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/input_port_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/alu_src_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/alu_op_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/ccr_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/modify_ccr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/branch_op_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/newSP_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/SP_WE_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/add_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_addr_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_data_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_WE_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_R_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_data_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_WE_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/ret_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/INT_state_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/is_load_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/swap_state_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/out_enable_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/HLT_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/predicted_T_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/HW_INT_ret_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/pc_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc1_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc2_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/imm_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_dst_addr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc1_addr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/rsrc2_addr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/input_port_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/alu_src_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/alu_op_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/ccr_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/modify_ccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/branch_op_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/newSP_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/SP_WE_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/add_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_addr_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_data_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_WE_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/mem_R_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_data_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/reg_WE_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/ret_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/INT_state_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/is_load_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/swap_state_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/out_enable_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_IDEX1/HLT_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/clk
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/flush
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/write_en
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/predicted_T
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/pc
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/HW_INT_ret
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ccr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/alu_res
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/rsrc1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/rsrc2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/imm
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_dst_addr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/input_port
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/alu_op
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ccr_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/modify_ccr
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/branch_op
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/newSP_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/SP_WE
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/add_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_addr_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_data_sel
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_WE
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_R
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_data
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_WE
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ret
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/INT_state
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/is_load
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/swap_state
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/out_enable
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/HLT
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/predicted_T_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/pc_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/HW_INT_ret_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ccr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/alu_res_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/rsrc1_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/rsrc2_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/imm_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_dst_addr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/input_port_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/alu_op_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ccr_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/modify_ccr_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/branch_op_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/newSP_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/SP_WE_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/add_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_addr_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_data_sel_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_WE_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_R_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_data_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_WE_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ret_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/INT_state_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/is_load_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/swap_state_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/out_enable_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/HLT_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/predicted_T_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/pc_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/HW_INT_ret_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/alu_res_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/rsrc1_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/rsrc2_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/imm_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_dst_addr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/input_port_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/alu_op_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ccr_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/modify_ccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/branch_op_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/newSP_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/SP_WE_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/add_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_addr_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_data_sel_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_WE_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/mem_R_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_data_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/reg_WE_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/ret_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/INT_state_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/is_load_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/swap_state_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/out_enable_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX1EX2/hlt_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/clk
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/rst
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/HLT_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/HLT_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/out_enable_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/out_enable_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/swap_state_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/swap_state_out_hazard_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/is_load_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/is_load_out_hazard_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/INT_state_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/INT_state_out_hazard_bccr_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/ret_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/ret_out_hazard_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/reg_WE_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/reg_WE_out_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/reg_data_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/reg_data_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_R_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_R_out_hazard_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_WE_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_WE_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_data_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_data_sel_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_addr_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/mem_addr_sel_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/add_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/SP_WE_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/SP_WE_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/newSP_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/newSP_sel_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/branch_op_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/modify_fl_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/ccr_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/alu_op_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/alu_op_out_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/pc_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/pc_out_branch_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/HW_INT_ret_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/HW_INT_ret_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/ccr_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/alu_result_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/alu_result_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/rsrc1_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/rsrc1_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/rsrc2_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/rsrc2_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/imm_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/imm_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/reg_dst_addr_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/reg_dst_addr_out_hazard_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/input_port_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/input_port_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/add_result_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/branch_decision_out_hazard
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/restore_flags_in
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/ccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/bccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/add_operand1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/add_operand2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_branch_tb/uut/u_EX2/add_sum
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/clk
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/flush
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/write_en
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/alu_res
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/rsrc1
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/rsrc2
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/mem_data_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/imm
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_dst_addr
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/input_port
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/alu_op
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_data
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_WE
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/ret
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/SW_INTDone
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/is_load
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/swap_state
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/out_enable
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/HLT
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/alu_res_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/rsrc1_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/rsrc2_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/mem_data_out_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/imm_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_dst_addr_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/input_port_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/alu_op_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_data_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_WE_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/ret_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/SW_INTDone_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/is_load_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/swap_state_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/out_enable_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/HLT_out
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/alu_res_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/rsrc1_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/rsrc2_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/mem_data_out_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/imm_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_dst_addr_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/input_port_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/alu_op_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_data_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/reg_WE_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/ret_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/SW_INTDone_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/is_load_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/swap_state_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/out_enable_str
add wave -noupdate -group { CCR} -color Orange /ta_branch_tb/uut/u_MEMWB/HLT_str
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rst
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/instruction_sel_decode
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/pc_we
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/inst_in_ifid
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rdst_in_id_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/is_load_from_IDEX1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/mem_r_from_id_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/swap_state_from_id_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/ret_from_id_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/int_state_id_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/hw_interrupt_active
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/halt_in_ex1_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/is_load_from_EX1EX2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rdst_in_ex1_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/mem_r_from_ex1_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/predicted_t_from_EX1EX2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/ret_from_ex1_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/int_state_ex1_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/branch_decision_from_EX2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/mem_r_from_EX2MEM
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/mem_we_from_EX2MEM
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/ret_from_ex2_mem
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/int_state_ex2_mem
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/ret_from_mem_wb
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/int_state_mem_wb
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rsrc1_sel_decode
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rdst_sel_decode
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/pc_src_sel
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/we_if_id
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/we_id_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/we_ex1_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/restore_flags_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/flush_if
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/flush_id
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/flush_ex1
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/flush_ex2
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/flush_mem
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/h_reset
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rsrc1_addr
add wave -noupdate -group { HAZARDS} -color Tan /ta_branch_tb/uut/u_hazard_unit/rsrc2_addr
add wave -noupdate -group { PC & FETCH} -color Yellow -radix hexadecimal /ta_branch_tb/fetch_pc_debug
add wave -noupdate -group { PC & FETCH} -color Yellow -radix hexadecimal /ta_branch_tb/uut/u_fetch_stage/pc_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5007 ns} 0}
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
WaveRestoreZoom {4926 ns} {5111 ns}
