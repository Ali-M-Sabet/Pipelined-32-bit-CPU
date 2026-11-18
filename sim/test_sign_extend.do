quit -sim
vsim -onfinish stop -voptargs=+acc work.sign_extend_tb
run 5 us
