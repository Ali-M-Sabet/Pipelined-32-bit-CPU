quit -sim
vsim -onfinish stop -voptargs=+acc work.conditional_jump_decoder_tb
run 5 us
