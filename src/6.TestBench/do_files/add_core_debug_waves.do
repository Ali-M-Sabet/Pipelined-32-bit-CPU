# Shared waveform probes for flags and stack pointer.
# Safe to call from any testbench: missing hierarchy paths are ignored.

proc add_core_debug_waves {} {
    set core_roots {
        sim:/ta_one_operand_tb/uut
        sim:/ta_two_operand_tb/uut
        sim:/ta_memory_tb/uut
        sim:/ta_branch_tb/uut
        sim:/top_level_tb/uut
    }

    foreach root $core_roots {
        catch {add wave -group "FLAGS" -color Orange -label C_Flag ${root}/u_EX2/ccr_str(2)}
        catch {add wave -group "FLAGS" -color Orange -label N_Flag ${root}/u_EX2/ccr_str(1)}
        catch {add wave -group "FLAGS" -color Orange -label Z_Flag ${root}/u_EX2/ccr_str(0)}
        catch {add wave -group "FLAGS" -color Orange -radix binary -label CCR ${root}/u_EX2/ccr_str}
        catch {add wave -group "FLAGS" -color Orange -radix binary -label Saved_CCR ${root}/u_EX2/bccr_str}
        catch {add wave -group "STACK_POINTER" -color Brown -radix hex -label SP ${root}/u_MEM/SP}
        catch {add wave -group "STACK_POINTER" -color Brown -radix hex -label New_SP ${root}/u_MEM/newSP}
    }

    catch {add wave -group "FLAGS" -color Orange -label C_Flag sim:/alu_tb/alu_flags(2)}
    catch {add wave -group "FLAGS" -color Orange -label N_Flag sim:/alu_tb/alu_flags(1)}
    catch {add wave -group "FLAGS" -color Orange -label Z_Flag sim:/alu_tb/alu_flags(0)}
    catch {add wave -group "FLAGS" -color Orange -radix binary -label ALU_Flags sim:/alu_tb/alu_flags}
}

add_core_debug_waves
rename add_core_debug_waves {}
