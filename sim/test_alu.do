quit -sim
vsim -onfinish stop -voptargs=+acc work.alu_tb
run 20 us
