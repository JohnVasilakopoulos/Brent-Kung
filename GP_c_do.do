add wave -position end  sim:/gp_c/a
add wave -position end  sim:/gp_c/b
add wave -position end  sim:/gp_c/g
add wave -position end  sim:/gp_c/p

force -freeze sim:/gp_c/a 0 0
force -freeze sim:/gp_c/b 0 0
run

force -freeze sim:/gp_c/a 0 0
force -freeze sim:/gp_c/b 1 0
run

force -freeze sim:/gp_c/a 1 0
force -freeze sim:/gp_c/b 0 0
run

force -freeze sim:/gp_c/a 1 0
force -freeze sim:/gp_c/b 1 0
run
