quit -sim
exec python assembler/assembler.py programs/two_operand.asm
vsim -onfinish stop -voptargs=+acc work.ta_two_operand_tb
do sim/waves/two_operand.do
run 4 us
