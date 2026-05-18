onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FLAGS -color Orange -label C_Flag /ta_two_operand_tb/uut/u_EX2/ccr_str(2)
add wave -noupdate -expand -group FLAGS -color Orange -label N_Flag /ta_two_operand_tb/uut/u_EX2/ccr_str(1)
add wave -noupdate -expand -group FLAGS -color Orange -label Z_Flag /ta_two_operand_tb/uut/u_EX2/ccr_str(0)
add wave -noupdate -expand -group FLAGS -color Orange -label CCR -radix binary /ta_two_operand_tb/uut/u_EX2/ccr_str
add wave -noupdate -expand -group FLAGS -color Orange -label Saved_CCR -radix binary /ta_two_operand_tb/uut/u_EX2/bccr_str
add wave -noupdate -expand -group STACK_POINTER -color Brown -label SP -radix hexadecimal /ta_two_operand_tb/uut/u_MEM/SP
add wave -noupdate -expand -group STACK_POINTER -color Brown -label New_SP -radix hexadecimal /ta_two_operand_tb/uut/u_MEM/newSP
add wave -noupdate -expand -group { CLOCK} -color Cyan /ta_two_operand_tb/clk
add wave -noupdate -expand -group {  CONTROL & RESET} -color Pink /ta_two_operand_tb/rst
add wave -noupdate -expand -group {  CONTROL & RESET} -color Pink /ta_two_operand_tb/core_enable
add wave -noupdate -expand -group { I/O PORTS} -color Blue -radix hexadecimal /ta_two_operand_tb/input_port
add wave -noupdate -expand -group { I/O PORTS} -color Blue -radix hexadecimal /ta_two_operand_tb/output_port
add wave -noupdate -expand -group { PC & FETCH} -color Yellow -radix hexadecimal /ta_two_operand_tb/fetch_pc_debug
add wave -noupdate -expand -group { REGISTERS} -color Magenta -radix hexadecimal -childformat {{/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(0) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(1) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(2) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(3) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(4) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(5) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(6) -radix hexadecimal} {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(7) -radix hexadecimal}} -expand -subitemconfig {/ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(0) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(1) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(2) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(3) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(4) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(5) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(6) {-color Magenta -radix hexadecimal} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers(7) {-color Magenta -radix hexadecimal}} /ta_two_operand_tb/uut/u_decode_stage/u_reg_file/registers
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_IFID/inst_out
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/HLT_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/HLT_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/out_enable_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/out_enable_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/swap_state_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/swap_state_out_hazard_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/is_load_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/is_load_out_hazard_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/INT_state_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/INT_state_out_hazard_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/ret_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/ret_out_hazard_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/reg_WE_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/reg_WE_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/reg_data_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/reg_data_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_R_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_R_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_WE_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_WE_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_data_sel_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_data_sel_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_addr_sel_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_addr_sel_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/add_sel_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/add_sel_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/SP_WE_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/SP_WE_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/newSP_sel_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/newSP_sel_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/branch_op_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/branch_op_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/modify_ccr_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/modify_ccr_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/ccr_sel_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/ccr_sel_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_op_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_op_out_alu_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_src_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/predicted_T_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/predicted_T_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/HW_INT_ret_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/HW_INT_ret_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/pc_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/pc_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc1_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/imm_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/imm_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/reg_dst_addr_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/reg_dst_addr_out_hazard_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc1_addr_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc1_addr_out_fwd
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_addr_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_addr_out_fwd
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/input_port_in_id_ex1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/input_port_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/ccr_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_result_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_res_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_res_in_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_res_in_mem_wb
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_in_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_in_mem_wb
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/input_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/input_in_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/input_in_mem_wb
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/mem_data_out_in_mem_wb
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/imm_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/imm_in_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/imm_in_mem_wb
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc1_fwd_sel_in_fwd
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_fwd_sel_in_fwd
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc1_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/rsrc2_out_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_input1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_input2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/alu_input2_mid
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/se_imm_local
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/se_imm_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/se_imm_in_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX1/se_imm_in_mem_wb
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/clk
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/rst
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/HLT_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/HLT_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/out_enable_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/out_enable_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/swap_state_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/swap_state_out_hazard_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/is_load_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/is_load_out_hazard_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/INT_state_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/INT_state_out_hazard_bccr_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/ret_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/ret_out_hazard_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/reg_WE_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/reg_WE_out_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/reg_data_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/reg_data_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_R_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_R_out_hazard_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_WE_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_WE_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_data_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_data_sel_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_addr_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/mem_addr_sel_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/add_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/SP_WE_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/SP_WE_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/newSP_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/newSP_sel_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/branch_op_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/modify_fl_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/ccr_sel_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/alu_op_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/alu_op_out_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/pc_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/pc_out_branch_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/HW_INT_ret_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/HW_INT_ret_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/ccr_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/alu_result_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/alu_result_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/rsrc1_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/rsrc1_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/rsrc2_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/rsrc2_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/imm_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/imm_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/reg_dst_addr_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/reg_dst_addr_out_hazard_fwd_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/input_port_in_ex1_ex2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/input_port_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/add_result_out_ex2_mem
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/branch_decision_out_hazard
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/restore_flags_in
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/ccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/bccr_str
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/add_operand1
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/add_operand2
add wave -noupdate -group { PIPELINE} -color Green -radix hexadecimal /ta_two_operand_tb/uut/u_EX2/add_sum
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/clk
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/flush
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/write_en
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/alu_res
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/rsrc1
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/rsrc2
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/mem_data_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/imm
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_dst_addr
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/input_port
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/alu_op
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_data
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_WE
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/ret
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/SW_INTDone
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/is_load
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/swap_state
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/out_enable
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/HLT
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/alu_res_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/rsrc1_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/rsrc2_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/mem_data_out_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/imm_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_dst_addr_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/input_port_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/alu_op_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_data_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_WE_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/ret_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/SW_INTDone_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/is_load_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/swap_state_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/out_enable_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/HLT_out
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/alu_res_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/rsrc1_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/rsrc2_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/mem_data_out_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/imm_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_dst_addr_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/input_port_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/alu_op_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_data_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/reg_WE_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/ret_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/SW_INTDone_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/is_load_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/swap_state_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/out_enable_str
add wave -noupdate -group { CCR} -color Navy -radix hexadecimal /ta_two_operand_tb/uut/u_MEMWB/HLT_str
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2653 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {3150 ns}
