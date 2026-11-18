quit -sim
exec python assembler/assembler.py programs/memory.asm
vsim -onfinish stop -voptargs=+acc work.ta_memory_tb
do sim/waves/memory.do
run 5 us
