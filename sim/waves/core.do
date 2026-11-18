add wave -divider {Clock and reset}
add wave ${core}/clk ${core}/rst ${core}/interrupt
add wave -divider {Execution}
add wave -radix hexadecimal ${core}/fetch_pc_debug ${core}/instruction_memory_data_out
add wave ${core}/core_enable
add wave -divider {Registers}
for {set i 0} {$i < 8} {incr i} {
    add wave -radix hexadecimal -label [format {R%d} $i] [format {%s/u_decode_stage/u_reg_file/registers(%d)} $core $i]
}
add wave -divider {Flags and stack}
add wave -radix binary ${core}/u_EX2/ccr_str
add wave -radix hexadecimal ${core}/u_MEM/SP
add wave -divider {Input and output}
add wave -radix hexadecimal ${core}/input_port ${core}/output_port
add wave -divider {Memory writes}
add wave ${core}/mem_we_from_MEM
add wave -radix hexadecimal ${core}/mem_addr_from_MEM ${core}/mem_write_data_from_MEM
