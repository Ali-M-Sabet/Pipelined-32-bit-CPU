quit -sim
exec python assembler/assembler.py programs/branch.asm
vsim -onfinish stop -voptargs=+acc work.top_level_tb
run 1 us
