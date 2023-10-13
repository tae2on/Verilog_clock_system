`timescale	1ns/10ps

module	tb_watch_time;


	parameter	STEP	= 20;	// 20ns
	
	reg	clk, rst, en_1hz; 
	wire	[13:0]	year; 
	wire	[7:0]	month, day, hour, min, sec, week;



	watch_time	TIME	(
					.clk					(clk),
					.clk1sec				(en_1hz),
					.rst					(rst),
					.year					(year),
					.month					(month),
					.day					(day),
					.hour					(hour),
					.min					(min),
					.sec					(sec));

	initial begin
		clk = 0; rst = 1; #(STEP/2);
		rst = 0; #30;
		rst = 1; en_1hz = 1; #(STEP*300000000);
		$stop;
	end

	always		#(STEP)		clk=~clk;
	
	always		#(STEP*50000000)		en_1hz = ~en_1hz;

endmodule
