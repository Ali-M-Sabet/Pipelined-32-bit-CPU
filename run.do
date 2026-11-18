if {[file exists work]} {
    vdel -all -lib work
}
vlib work
vcom -2008 src/components/*.vhd
vcom -2008 src/control/*.vhd
vcom -2008 src/pipeline/*.vhd
vcom -2008 src/stages/*.vhd
vcom -2008 src/top_level.vhd
vcom -2008 tb/*.vhd
exec python assembler/assembler.py programs/branch.asm
vsim -onfinish stop -voptargs=+acc work.ta_branch_tb
do sim/waves/branch.do
run -all
