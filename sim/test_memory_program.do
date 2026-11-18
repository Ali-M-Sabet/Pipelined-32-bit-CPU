quit -sim
exec python assembler/assembler.py programs/memory.asm
vsim -onfinish stop -voptargs=+acc work.memory_program_tb
run 5 us
