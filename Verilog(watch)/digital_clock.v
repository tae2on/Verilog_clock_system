module	Digital_clock	(
								clk,
								rst,
								dip_sw,
								sw_in,
								lcd_rs,
								lcd_rw,
								lcd_e,
								lcd_data,
								rx_serial,
								tx_serial,
								tx_busy);
									
	input					 clk, rst;
	input			[3:0]  dip_sw;
	input			[3:0]	 sw_in;
	input					 rx_serial;
	
	output				 lcd_rs;
	output				 lcd_rw;
	output				 lcd_e;
	output		[7:0]  lcd_data;
	output				 tx_serial;
	output				 tx_busy;
	
	parameter CLKS_PER_BIT = 5208;
	parameter STOP_BIT	  = 1;
		
	reg			[51:0] transfer_time, transfer_alarm;
	reg			[3:0]	 sw_out;
	reg			[7:0]	 data_char;
	
	wire					 en_sig;
	wire			[3:0]	 cnt_bcd;
	wire			[7:0]	 bcd_ascii;
	wire					 ring_alarm;
	wire			[13:0] year;
	wire			[7:0]	 month;
	wire			[7:0]	 day, hour, min, sec;
	wire			[4:0]  index_char;
	wire					 en_1hz;
	wire					 en_clk;
	wire					 en_time, set_alarm;
	wire			[3:0]	 sw_in;
	wire			[3:0]  dip_sw;
	wire			[2:0]  week;
	wire					 en_100hz;
	wire			[7:0]  watch_mode, set_mode, alarm_mode, uart_mode;
	wire			[3:0]	 watch_sw, set_sw, alarm_sw, uart_sw;
	wire			[7:0]	 data;
	

	assign		rstn = ~rst;
	
	switch						M0		(
										.dip					(dip_sw),
										.sw					(sw_out),
										.data					(data),
										.rx_done				(rx_done),
										.out0					(watch_sw),
										.out1					(set_sw),
										.out2					(alarm_sw),
										.out3					(uart_sw));
										
	out_data						M1		(
										.dip					(dip_sw),
										.watch				(watch_mode),
										.set					(set_mode),
										.alarm				(alarm_mode),
										.uart					(uart_mode),
										.data					(data),
										.rx_done				(rx_done),
										.out					(data_char));
	
	debouncer_clk				sw0	(
										.clk					(clk),
										.rst					(rstn),
										.in					(sw_in[0]),
										.out					(sw_out[0]));
										
	debouncer_clk				sw1	(
										.clk					(clk),
										.rst					(rstn),
										.in					(sw_in[1]),
										.out					(sw_out[1]));
										
	debouncer_clk				sw2	(
										.clk					(clk),
										.rst					(rstn),
										.in					(sw_in[2]),
										.out					(sw_out[2]));
										
	debouncer_clk				sw3	(
										.clk					(clk),
										.rst					(rstn),
										.in					(sw_in[3]),
										.out					(sw_out[3]));
	
	
	en_clk						U0		(
										.clk					(clk),
										.rst					(rstn),
										.en_1hz				(en_1hz));
								
	
	watch_time					TIME	(
										.clk					(clk),
										.clk1sec				(en_1hz),
										.rst					(rstn),
										.set_time			(en_time),
										.transfer_time		(transfer_time),
										.year					(year),
										.month				(month),
										.day					(day),
										.hour					(hour),
										.min					(min),
										.sec					(sec),
										.week					(week),
										.max_date			(max_d));
										
	mode_watch					MODE0	( 	
										.clk					(clk), 
										.clk1sec				(en_1hz),
										.rst					(rstn), 
										.sw_in				(watch_sw),
										.year					(year),
										.month				(month),
										.day					(day),
										.hour					(hour),
										.min					(min),
										.sec					(sec),
										.index				(index_char),
										.out					(watch_mode),
										.transfer_alarm	(transfer_alarm),
										.week					(week),
										.rst_alarm			(rst_alarm),
										.ring_alarm			(ring_alarm));
										
	mode_watch_set				MODE1 (
										.clk					(clk),
										.clk1sec				(en_1hz),
										.rst					(rstn),
										.sw_in				(set_sw),
										.year					(year),
										.month				(month),
										.day					(day),
										.hour					(hour),
										.min					(min),
										.sec					(sec),
										.transfer_time		(transfer_time),
										.en_time				(en_time),
										.index				(index_char),
										.out					(set_mode));
										
	
	mode_uart_tx_alarm		MODE2	(
										.clk					(clk),
										.clk1sec				(en_1hz),
										.rst					(rstn),
										.sw_in				(alarm_sw),
										.year					(year),
										.month				(month),
										.day					(day),
										.hour					(hour),
										.min					(min),
										.sec					(sec),
										.index				(index_char),
										.out					(alarm_mode),
										.transfer_alarm	(transfer_alarm),
										.rst_alarm			(rst_alarm));
									
	mode_uart					MODE3	(
										.clk					(clk),
										.rst					(rstn),
										.clk1sec				(en_1hz),
										.sw_in				(uart_sw),
										.index				(index_char),
										.out					(uart_mode));								
			
	en_clk_lcd					LCLK	( 
										.clk					(clk),
										.rst					(rstn),
										.en_clk				(en_clk));
										
	lcd_driver					DRV	(	
										.clk					(clk),
										.rst					(rstn),
										.en_clk				(en_clk),
										.data_char			(data_char),
										.index_char			(index_char),
										.lcd_rs				(lcd_rs),
										.lcd_rw				(lcd_rw),
										.lcd_e				(lcd_e),
										.lcd_data			(lcd_data));
										
	en_txsig						E0 	(
										.clk					(clk),
										.rst					(rstn),
										.en_sig				(en_sig));
	
	bcd_counter					E1 	(
										.clk					(clk),
										.rst					(rstn),
										.en_sig				(en_sig),
										.cnt_bcd 			(cnt_bcd));
	
	bcd2ascii					E2		(
										.clk					(clk),
										.rst					(rstn),
										.cnt_bcd 			(cnt_bcd),
										.bcd_ascii			(bcd_ascii));
	
	uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT), .STOP_BIT(STOP_BIT)) E3 (
										.clk					(clk),
										.rst					(rstn),
										.dip					(dip_sw),
										.tx_en	 			(en_sig),
										.en_alarm			(ring_alarm),
										.din					(bcd_ascii),
										.tx					(tx_serial),
										.tx_busy				(tx_busy));
										
	uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT), .STOP_BIT(STOP_BIT)) E4 (
										.clk					(clk),
										.rst					(rstn),
										.rx					(rx_serial),
										.data					(data),
										.rx_done				(rx_done));										
										
endmodule
