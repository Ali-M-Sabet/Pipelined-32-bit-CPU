quit -sim
vsim -onfinish stop -voptargs=+acc work.register_file_outputs_tb
run 5 us
