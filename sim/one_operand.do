quit -sim
exec python assembler/assembler.py programs/one_operand.asm
vsim -onfinish stop -voptargs=+acc work.ta_one_operand_tb
do sim/waves/one_operand.do
run 3 us
