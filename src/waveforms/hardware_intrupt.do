onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB /hardware_interrupt_tb/clk
add wave -noupdate -group TB /hardware_interrupt_tb/rst
add wave -noupdate -group TB /hardware_interrupt_tb/interrupt
add wave -noupdate -group TB /hardware_interrupt_tb/core_enable
add wave -noupdate -group TB -radix hexadecimal /hardware_interrupt_tb/output_port
add wave -noupdate -group TB -radix unsigned /hardware_interrupt_tb/fetch_pc_debug
add wave -noupdate -group TB /hardware_interrupt_tb/pass_index_seen
add wave -noupdate -group TB /hardware_interrupt_tb/saw_failure
add wave -noupdate -expand -group Fetch -radix unsigned /hardware_interrupt_tb/uut/u_fetch_stage/pc_reg
add wave -noupdate -expand -group Fetch -radix unsigned /hardware_interrupt_tb/uut/u_fetch_stage/pc_plus1
add wave -noupdate -expand -group Fetch -radix unsigned /hardware_interrupt_tb/uut/u_fetch_stage/pc_in
add wave -noupdate -expand -group Fetch -radix binary /hardware_interrupt_tb/uut/hz_pc_src_sel
add wave -noupdate -expand -group Fetch -radix hexadecimal /hardware_interrupt_tb/uut/instruction_memory_data_out
add wave -noupdate -expand -group Fetch -radix unsigned /hardware_interrupt_tb/uut/mem_addr_out_fetch
add wave -noupdate -expand -group Vectors -radix hexadecimal /hardware_interrupt_tb/uut/u_instruction_memory/mem(0)
add wave -noupdate -expand -group Vectors -radix hexadecimal /hardware_interrupt_tb/uut/u_instruction_memory/mem(1)
add wave -noupdate -expand -group Interrupt -radix binary /hardware_interrupt_tb/uut/int_state_to_IDEX1
add wave -noupdate -expand -group Interrupt -radix binary /hardware_interrupt_tb/uut/int_state_from_IDEX1
add wave -noupdate -expand -group Interrupt -radix binary /hardware_interrupt_tb/uut/int_state_from_EX1EX2
add wave -noupdate -expand -group Interrupt -radix binary /hardware_interrupt_tb/uut/int_state_from_EX2MEM
add wave -noupdate -expand -group Interrupt -radix binary /hardware_interrupt_tb/uut/sw_intdone_from_MEMWB
add wave -noupdate -expand -group Interrupt /hardware_interrupt_tb/uut/hw_interrupt_request
add wave -noupdate -expand -group Interrupt /hardware_interrupt_tb/uut/hw_interrupt_active
add wave -noupdate -expand -group Interrupt /hardware_interrupt_tb/uut/hw_interrupt_done
add wave -noupdate -expand -group Interrupt /hardware_interrupt_tb/uut/ret_from_MEMWB
add wave -noupdate -expand -group {Stack/Data Memory} -radix unsigned /hardware_interrupt_tb/uut/u_MEM/SP
add wave -noupdate -expand -group {Stack/Data Memory} -radix unsigned /hardware_interrupt_tb/uut/mem_addr_from_MEM
add wave -noupdate -expand -group {Stack/Data Memory} -radix hexadecimal /hardware_interrupt_tb/uut/mem_write_data_from_MEM
add wave -noupdate -expand -group {Stack/Data Memory} /hardware_interrupt_tb/uut/mem_we_from_MEM
add wave -noupdate -expand -group {Stack/Data Memory} /hardware_interrupt_tb/uut/mem_r_from_MEM
add wave -noupdate -expand -group {Stack/Data Memory} -radix hexadecimal /hardware_interrupt_tb/uut/data_memory_data_out
add wave -noupdate -expand -group {Stack/Data Memory} -radix hexadecimal /hardware_interrupt_tb/uut/mem_data_out_from_MEMWB
add wave -noupdate -group CCR -radix binary /hardware_interrupt_tb/uut/u_EX2/ccr_str
add wave -noupdate -group CCR -radix binary /hardware_interrupt_tb/uut/u_EX2/bccr_str
add wave -noupdate -group CCR /hardware_interrupt_tb/uut/hz_restore_flags_ex2
add wave -noupdate -group Hazard /hardware_interrupt_tb/uut/hz_pc_we
add wave -noupdate -group Hazard -radix binary /hardware_interrupt_tb/uut/hz_instruction_sel_decode
add wave -noupdate -group Hazard /hardware_interrupt_tb/uut/hz_flush_if
add wave -noupdate -group Hazard /hardware_interrupt_tb/uut/hz_flush_id
add wave -noupdate -group Hazard /hardware_interrupt_tb/uut/hz_flush_ex1
add wave -noupdate -group Hazard /hardware_interrupt_tb/uut/hz_flush_ex2
add wave -noupdate -group Hazard /hardware_interrupt_tb/uut/hz_flush_mem
add wave -noupdate -expand -group Output -radix hexadecimal /hardware_interrupt_tb/uut/output_port
add wave -noupdate -expand -group Output /hardware_interrupt_tb/uut/out_enable_from_MEMWB
add wave -noupdate -expand -group Output -radix hexadecimal /hardware_interrupt_tb/uut/rsrc1_from_MEMWB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1685 ns} 0}
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
WaveRestoreZoom {1287 ns} {2449 ns}
