quit -sim
vsim -onfinish stop -voptargs=+acc work.zero_extend_tb
run 5 us
