transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/digital_clock.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/switch.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/out_data.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/debouncer_clk.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/clk_div.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/d_ff.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/en_clk.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/watch_time.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/mode_watch.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/place_2value.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/place_3value.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/mode_watch_set.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/mode_uart_tx_alarm.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/mode_uart.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/en_clk_lcd.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/lcd_driver.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/en_txsig.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/bcd_counter.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/bcd2ascii.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/uart_tx.v}
vlog -vlog01compat -work work +incdir+E:/Teamproject {E:/Teamproject/uart_rx.v}

