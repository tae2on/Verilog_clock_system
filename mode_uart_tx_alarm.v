module mode_uart_tx_alarm	(
						clk,
						clk1sec,
						rst,
						sw_in,
						year,
						month,
						day,
						hour,
						min,
						sec,
						index,
						out,
						transfer_alarm,
						rst_alarm);
					
	input				 clk, rst;
	input				 clk1sec;
	input		[3:0]  sw_in;
	input		[13:0] year;
	input		[7:0]	 month, day, hour, min, sec;
	input		[4:0]	 index;
	input				 rst_alarm;
	
	output	[7:0]	 out;
	output	[51:0] transfer_alarm;
		
	reg		[7:0]	 out;
	reg		[13:0] year_alarm;
	reg		[7:0]	 month_alarm, day_alarm, hour_alarm, min_alarm, sec_alarm;
	reg				 blink;
	reg		[2:0]  location;
	reg		[51:0] transfer_alarm;
	reg				 set_alarm;
	reg		[4:0]  max_date;
	reg		[7:0]	 kor_hour, kor_min, kor_day;

	
	wire				 leap_year;
	wire		[4:0]	 index;
	wire		[3:0]  tho_year, hun_year, ten_year, one_year, ten_month, one_month, ten_day, one_day;
	wire		[3:0]	 ten_hour, one_hour, ten_min, one_min, ten_sec, one_sec;
	
	
	assign leap_year = (((year_alarm % 4) == 0 && (year_alarm % 100) != 0) || (year_alarm % 400) == 0) ? 1'b1 : 1'b0;
	
	always @(posedge clk1sec) begin
		blink 	<= 1 - blink;
	end
										
	place_2value				KOR_second (
										.clk				(clk),
										.place_bcd		(sec_alarm),
										.rst				(rst),
										.ten				(ten_sec),
										.one				(one_sec));
										
	place_2value			 	KOR_minute (
										.clk				(clk),
										.place_bcd		(kor_min),
										.rst				(rst),
										.ten				(ten_min),
										.one				(one_min));									
	
	place_2value				KOR_hour (
										.clk				(clk),
										.place_bcd		(kor_hour),
										.rst				(rst),
										.ten				(ten_hour),
										.one				(one_hour));
										
	place_2value				KOR_day (
										.clk				(clk),
										.place_bcd		(kor_day),
										.rst				(rst),
										.ten				(ten_day),
										.one				(one_day));
										
	place_2value				KOR_month (
										.clk				(clk),
										.place_bcd		(month_alarm),
										.rst				(rst),
										.ten				(ten_month),
										.one				(one_month));

	place_3value				KOR_year (
										.clk				(clk),
										.place_bcd		(year_alarm),
										.rst				(rst),
										.tho				(tho_year),
										.hun				(hun_year),
										.ten				(ten_year),
										.one				(one_year));
					
					
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			out	 	<=	8'h00;
			location <=	3'd0;
		end
		else begin
			case(month_alarm)
				8'd1, 8'd3, 8'd5, 8'd7, 8'd8, 8'd10, 8'd12 :	max_date	<= 8'd31;
				8'd2 													 : max_date	<= 8'd28 + leap_year;
				8'd4, 8'd6, 8'd9, 8'd11							 : max_date <=	8'd30;
				default 												 : max_date <= 0;
			endcase
			
			// hour calculation
			kor_day	=	day_alarm;
			kor_hour	=	hour_alarm;
			kor_min	=	min_alarm;
			
			if(kor_hour	>= 8'd24) begin
				kor_hour = hour_alarm - 8'd24;
				kor_day  = day_alarm + 8'd1;
			end
			
			if(kor_min	>= 8'd60) begin
				kor_min  = min_alarm - 8'd60;
				kor_hour = hour_alarm + 8'd1;
				
				if(kor_hour	>= 8'd24) begin
					kor_hour = hour_alarm - 8'd23;
					kor_day  = day_alarm + 8'd1;
				end
			end
			
			if(kor_day > max_date) begin
				kor_day = 8'd1;
			end
		
		
			// alarm (LCD line 1)
			case (index)
				00 : out <= 8'h41;							//A
				01 : out	<=	8'h4C;							//L
				02 : out	<=	8'h41;							//A
				03 : out	<=	8'h52;							//R
				04 : out	<=	8'h4D;							//M
				05 : 	if(blink && location == 3'd0)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + tho_year;
							
				06 :	if(blink && location == 3'd0)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + hun_year;
							
				07 :	if(blink && location == 3'd0)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + ten_year;
							
				08 :	if(blink && location == 3'd0)	
							out	<=	8'h20;
						else
							out	<=	8'h30 + one_year;
							
				09 : out	<=	8'h59;							//Y
				
				10 :	if(blink && location == 3'd1)
							out	<=	8'h20;
						else
							out	<=	8'h30 + ten_month;
							
				11 :	if(blink && location == 3'd1)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_month;
							
				12 : out	<=	8'h4D;							//M
				
				13 :	if(blink && location == 3'd2)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + ten_day;
							
				14 :	if(blink && location == 3'd2)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_day;
							
				15 : out	<=	8'h44;							//D
				
				
				// LCD line2
				16 : out <= 8'h53;							//S
				17 : out	<=	8'h45;							//E
				18 : out	<=	8'h54;							//T
				19 : out	<=	8'h20;
				20 : out	<=	8'h20;
				
				21 :	if(blink && location == 3'd3)
							out	<=	8'h20;
						else
							out	<=	8'h30 + ten_hour;
							
				22 :	if(blink && location == 3'd3)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_hour;
							
				23 : out	<=	8'h48;							//H
				
				24 :	if(blink && location == 3'd4)
							out	<=	8'h20;
						else
							out	<=	8'h30 + ten_min;
							
				25 :	if(blink && location == 3'd4)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_min;
							
				26 : out	<=	8'h4D;							//M
				
				27 :	if(blink && location == 3'd5)
							out	<=	8'h20;
						else
							out	<=	8'h30 + ten_sec;
							
				28 :	if(blink && location == 3'd5)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_sec;
							
				29 : out	<=	8'h53;							//S
				30 : out	<=	8'h20;
				
				31 : 	if(blink && location == 3'd6)
							out	<=	8'h20;
						else
							out	<=	8'h7E;					//->
			endcase
			
			
			if(transfer_alarm == 0)
				set_alarm <= 1'b0;
					
			if(sw_in == 4'b1000 && location < 3'd6) 					// SW 4 : ->
				location	<=	location + 1;
				
			else if(sw_in == 4'b0100 && location > 3'd0) 			// SW 3 : <-
				location	<=	location - 1;
				
			else if(sw_in == 4'b0010) begin 								// sw 2 : +
				if(location == 3'd0 && year_alarm < 14'd9999)
					year_alarm 		<= year_alarm + 1;
					
				else if(location == 3'd1 && month_alarm < 8'd12)
					month_alarm		<= month_alarm + 1;
					
				else if(location == 3'd2 && day_alarm < max_date)
					day_alarm		<=	day_alarm + 1;
					
				else if(location == 3'd3 && hour_alarm < 8'd23)
					hour_alarm		<=	hour_alarm + 1;
					
				else if(location == 3'd4 && min_alarm < 8'd59)
					min_alarm		<=	min_alarm + 1;
					
				else if(location == 3'd5 && sec_alarm < 8'd59)
					sec_alarm		<=	sec_alarm + 1;
					
				else if(location == 3'd6) begin							// -> push sw 2 : reset
					year_alarm	<=	12'd0;
					month_alarm	<=	8'd0;
					day_alarm	<=	8'd0;
					hour_alarm	<=	8'd0;
					min_alarm<=	8'd0;
					sec_alarm<=	8'd0;
				end
			end
			
			else if(sw_in == 4'b0001) begin								// SW 1 : -
				if(location == 3'd0 && year_alarm > 1)
					year_alarm 	<= year_alarm - 1;
					
				else if(location == 3'd1 && month_alarm > 1)
					month_alarm	<= month_alarm - 1;
					
				else if(location == 3'd2 && day_alarm > 1)
					day_alarm		<=	day_alarm - 1;
					
				else if(location == 3'd3 && hour_alarm > 0)
					hour_alarm		<=	hour_alarm - 1;
					
				else if(location == 3'd4 && min_alarm > 0)
					min_alarm		<=	min_alarm - 1;
					
				else if(location == 3'd5 && sec_alarm > 0)
					sec_alarm		<=	sec_alarm - 1;
					
				else if(location == 3'd6) begin							// -> push sw 1 : year, month, day, hour, min, sec
					year_alarm	<=	year;
					month_alarm	<=	month;
					day_alarm	<=	day;
					hour_alarm	<=	hour;
					min_alarm	<=	min;
					sec_alarm	<=	sec;
					
				end
			end
			
			if(rst_alarm == 1'b1) begin	// mode 0 push sw 2 : reset
				year_alarm	<=	12'd0;
				month_alarm	<=	8'd0;
				day_alarm	<=	8'd0;
				hour_alarm	<=	8'd0;
				min_alarm	<=	8'd0;
				sec_alarm	<=	8'd0;
			end
			
			transfer_alarm		<=	{year_alarm, month_alarm, day_alarm, hour_alarm, min_alarm, sec_alarm};
			
		end
	end
	
endmodule

	