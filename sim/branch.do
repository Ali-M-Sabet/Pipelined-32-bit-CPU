quit -sim
exec python assembler/assembler.py programs/branch.asm
vsim -onfinish stop -voptargs=+acc work.ta_branch_tb
do sim/waves/branch.do
run -all
