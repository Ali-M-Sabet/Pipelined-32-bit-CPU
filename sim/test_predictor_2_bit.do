quit -sim
vsim -onfinish stop -voptargs=+acc work.predictor_2_bit_tb
run 5 us
