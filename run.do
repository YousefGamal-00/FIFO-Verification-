vlib work
vlog -f src_files.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.FIFO_top -cover

add wave -position insertpoint  \
sim:/FIFO_top/FIFO_if_obj/clk \
sim:/FIFO_top/FIFO_if_obj/rst_n \
sim:/FIFO_top/FIFO_if_obj/wr_en \
sim:/FIFO_top/FIFO_if_obj/rd_en \
sim:/FIFO_top/FIFO_if_obj/data_in \
sim:/FIFO_top/FIFO_if_obj/wr_ack \
sim:/FIFO_top/DUT/count \
sim:/FIFO_top/monitor_obj/F_sb.counter \
sim:/FIFO_top/FIFO_if_obj/overflow \
sim:/FIFO_top/FIFO_if_obj/full \
sim:/FIFO_top/FIFO_if_obj/empty \
sim:/FIFO_top/FIFO_if_obj/almostfull \
sim:/FIFO_top/FIFO_if_obj/almostempty \
sim:/FIFO_top/FIFO_if_obj/underflow \
sim:/FIFO_top/FIFO_if_obj/data_out 
add wave /FIFO_top/DUT/assert_reset_falgs
add wave /FIFO_top/DUT/assert_empty
add wave /FIFO_top/DUT/assert_full
add wave /FIFO_top/DUT/assert_almostfull
add wave /FIFO_top/DUT/assert_almostempty
add wave /FIFO_top/DUT/RD_PTR_assert
add wave /FIFO_top/DUT/WR_PTR_assert
add wave /FIFO_top/DUT/assert_overflow
add wave /FIFO_top/DUT/assert_underflow
add wave /FIFO_top/DUT/assert_wr_ack_1
add wave /FIFO_top/DUT/assert_wr_ack_0
coverage save FIFO_top.ucdb -onexit -du work.FIFO
run -all

# quit -sim
# vcover report FIFO_top.ucdb -details -annotate -all -output fifo_cov_CC_AS_report.txt
