module	mode_watch_set ( 
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
								transfer_time,
								en_time,
								index,
								out);
					
	input				 clk, rst;
	input				 clk1sec;
	input		[3:0]  sw_in;
	input		[13:0] year;
	input		[7:0]	 month, day, hour, min, sec;
	input		[4:0]	 index;
	
	output	[51:0] transfer_time;
	output			 en_time;
	output	[7:0]	 out;
						
	reg				 en_time;
	reg		[51:0] transfer_time;
	reg		[13:0] year_set;
	reg		[7:0]  month_set, day_set, hour_set, min_set, sec_set;
	reg		[7:0]	 out;
	reg				 blink;
	reg		[2:0]  location;
	reg		[4:0]	 max_date;
	reg		[7:0]  kor_hour, kor_min, kor_day;
	
	wire		[4:0]	 index;
	wire		[13:0] year;
	wire		[7:0]	 month, day, hour, min, sec;
	wire		[3:0]  tho_year, hun_year, ten_year , one_year, ten_month, one_month, ten_day, one_day;
	wire		[3:0]	 ten_hour, one_hour, ten_min, one_min, ten_sec, one_sec;
	wire				 leap_year;
	
	assign leap_year = (((year_set % 4) == 0 && (year_set % 100) != 0) || (year_set % 400) == 0) ? 1'b1 : 1'b0;
	
	always @(posedge clk1sec) begin
		blink 	<= 1 - blink;
	end
										
	place_2value				KOR_second (
										.clk				(clk),
										.place_bcd		(sec_set),
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
										.place_bcd		(month_set),
										.rst				(rst),
										.ten				(ten_month),
										.one				(one_month));

	place_3value				KOR_year (
										.clk				(clk),
										.place_bcd		(year_set),
										.rst				(rst),
										.tho				(tho_year),
										.hun				(hun_year),
										.ten				(ten_year),
										.one				(one_year));
										
	always @ ( posedge clk or negedge rst )begin
		if(!rst)begin
			out	 	<=	8'h00;
			location <=	3'd0;
		end
		else begin
			// date
			case(month_set)
				8'd1, 8'd3, 8'd5, 8'd7, 8'd8, 8'd10, 8'd12 :	
						max_date	<= 8'd31;
				8'd2 :	
						max_date	<= 8'd28 + leap_year;
				8'd4, 8'd6, 8'd9, 8'd11	:
						max_date <=	8'd30;
				default : 
						max_date <= 0;
			endcase
			
			// hour calculation
			kor_day	=	day_set;
			kor_hour	=	hour_set;
			kor_min	=	min_set;
			
			if(kor_hour	>= 8'd24)begin
				kor_hour= hour_set - 8'd24;
				kor_day = day_set + 8'd1;
			end
			if(kor_min	>= 8'd60)begin
				kor_min = min_set - 8'd60;
				kor_hour= hour_set + 8'd1;
				if(kor_hour	>= 8'd24)begin
					kor_hour= hour_set - 8'd23;
					kor_day = day_set + 8'd1;
				end
			end
			if(kor_day > max_date)begin
				kor_day = 8'd1;
			end
				
			// watch_set
			case (index)
				00 : out <= 8'h53;								//S
				01 : out	<=	8'h45;								//E
				02 : out	<=	8'h54;								//T
				03 : out	<=	8'h20;
				04 : out	<=	8'h20; 		
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
				09 : out	<=	8'h59;								//Y
				10 :	if(blink && location == 3'd1)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + ten_month;
				11 :	if(blink && location == 3'd1)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_month;
				12 : out	<=	8'h4D;								//M
				13 :	if(blink && location == 3'd2)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + ten_day;
				14 :	if(blink && location == 3'd2)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + one_day;
				15 : out	<=	8'h44;								//D
				
				
				// line2
				16 : out	<=	8'h54;								//T
				17 : out	<=	8'h49;								//I
				18 : out	<=	8'h4D;								//M
				19 : out	<=	8'h45;								//E
				20 : out	<=	8'h20;
				21 :	if(blink && location == 3'd3)
							out	<=	8'h20;
						else
							out	<=	8'h30 + ten_hour;
				22 :	if(blink && location == 3'd3)
							out	<=	8'h20;
						else
							out	<=	8'h30 + one_hour;
				23 : out	<=	8'h48;								//H
				24 :	if(blink && location == 3'd4)
							out	<=	8'h20;
						else	
							out	<=	8'h30 + ten_min;
				25 :	if(blink && location == 3'd4)
							out	<=	8'h20;
						else
							out	<=	8'h30 + one_min;
				26 : out	<=	8'h4D;								//M
				27 :	if(blink && location == 3'd5)
							out	<=	8'h20;
						else
							out	<=	8'h30 + ten_sec;
				28 :	if(blink && location == 3'd5)
							out	<=	8'h20;
						else
							out	<=	8'h30 + one_sec;
				29 : out	<=	8'h53;								//S
				30 : out	<=	8'h20;
				31 : 	if(blink && location == 3'd6)
							out	<=	8'h20;
						else	
							out	<=	8'h7E;						//->
			endcase
			
			en_time		<= 1'b0;
			if(sw_in == 4'b1000 && location < 3'd6)
				location	<=	location + 1;
			else if(sw_in == 4'b0100 && location > 3'd0)
				location	<=	location - 1;
			else if(sw_in == 4'b0010)begin
				if(location == 3'd0 && year_set < 14'd9999)
					year_set 	<= year_set + 1;
				else if(location == 3'd1 && month_set < 8'd12)
					month_set	<= month_set + 1;
				else if(location == 3'd2 && day_set < max_date)
					day_set		<=	day_set + 1;
				else if(location == 3'd3 && hour_set < 8'd23)
					hour_set		<=	hour_set + 1;
				else if(location == 3'd4 && min_set < 8'd59)
					min_set		<=	min_set + 1;
				else if(location == 3'd5 && hour_set < 8'd59)		//sec_set
					sec_set		<=	sec_set + 1;
				else if(location == 3'd6)begin
					en_time		<= 1'b1;
				end
			end
			else if(sw_in == 4'b0001)begin
				if(location == 3'd0 && year_set > 1)
					year_set 	<= year_set - 1;
				else if(location == 3'd1 && month_set > 1)
					month_set	<= month_set - 1;
				else if(location == 3'd2 && day_set > 1)
					day_set		<=	day_set - 1;
				else if(location == 3'd3 && hour_set > 0)
					hour_set		<=	hour_set - 1;
				else if(location == 3'd4 && min_set > 0)
					min_set		<=	min_set - 1;
				else if(location == 3'd5 && sec_set > 0)
					sec_set		<=	sec_set - 1;
				else if(location == 3'd6)begin
					year_set		<= year;
					month_set	<=	month;
					day_set		<=	day;
					hour_set		<=	hour;
					min_set		<=	min;
					sec_set		<=	sec;
				end
			end
			transfer_time		<=	{year_set, month_set, day_set, hour_set, min_set, sec_set};
		end
	end
endmodule
		
		
			
			