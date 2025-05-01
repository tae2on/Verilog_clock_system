 	module mode_watch	(			
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
							rst_alarm,
							week,
							ring_alarm);
	
	input				 clk;
	input				 clk1sec;
	input				 rst;
	input		[3:0]	 sw_in;
	input		[13:0] year;
	input		[7:0]  month, day, hour, min, sec;
	input		[4:0]  index;
	input		[51:0] transfer_alarm;
	input		[2:0]  week;
	
	output	[7:0]  out;
	output	[7:0]  rst_alarm;
	output			 ring_alarm;

	reg		[7:0]	 kor_day, kor_hour, kor_min;
	reg		[2:0]	 calweek;
	reg		[51:0] current_time;
	reg		[7:0]  out;
	reg				 blink;
	reg				 rst_alarm;
	reg		[4:0]  max_date;
	reg				 h12or24;
	reg		[7:0]	 HmodeChar;
	reg				 ring_alarm;
	
	wire		[3:0]	 sw;
	wire		[4:0]  index;
	wire		[3:0]  tho_year, hun_year, ten_year , one_year, ten_month, one_month, ten_day, one_day;
	wire		[3:0]	 ten_hour, one_hour, ten_min, one_min, ten_sec, one_sec;
	wire		[13:0] year;
	wire		[7:0]  month, day, hour, min, sec;
	wire				 leap_year;
		
	assign leap_year = (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0) ? 1'b1 : 1'b0;
	
	place_2value				KOR_second (
										.clk				(clk),
										.place_bcd		(sec),
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
										.place_bcd		(month),
										.rst				(rst),
										.ten				(ten_month),
										.one				(one_month));

	place_3value				KOR_year (
										.clk				(clk),
										.place_bcd		(year),
										.rst				(rst),
										.tho				(tho_year),
										.hun				(hun_year),
										.ten				(ten_year),
										.one				(one_year));
							
							
	always @(posedge clk1sec) begin
		blink 	<= 1 - blink;
	end
	
	always @(*)
		case(month)
				8'd1, 8'd3, 8'd5, 8'd7, 8'd8, 8'd10, 8'd12 :	max_date	<= 8'd31;
				8'd2 													 : max_date	<= 8'd28 + leap_year;
				8'd4, 8'd6, 8'd9, 8'd11							 : max_date <=	8'd30;
				default 												 : max_date <= 0;
		endcase
	
	always @ ( posedge clk or negedge rst )begin
		if(!rst)begin
			out		<= 8'h00;
			rst_alarm<= 1'b0;
			h12or24	<= 1'b0;
		end
		
		else begin
			if(sw_in == 4'b0010 && transfer_alarm > 0 && current_time > transfer_alarm)
				rst_alarm <= 1'b1;
			else
				rst_alarm <= 1'b0;
			if(sw_in	==	4'b0001)
				h12or24	=	1 - h12or24;
				
			// hour calculation	
			calweek  =  week;
			kor_day	=	day;
			kor_hour	=	hour;
			kor_min	=	min;
			
			if(kor_hour	>= 8'd24)begin
				kor_hour = hour - 8'd24;
				kor_day  = day + 8'd1;
				calweek  = week + 3'd1;
				if(calweek == 3'd7)
					calweek = 3'd0;
			end
			if(kor_min	>= 8'd60)begin
				kor_min = min - 8'd60;
				kor_hour= hour + 8'd1;
				if(kor_hour	>= 8'd24)begin
					kor_hour = hour - 8'd23;
					kor_day  = day + 8'd1;
					calweek  = week + 3'd1;
					if(calweek == 3'd7)
						calweek = 3'd0;
				end
			end
			if(kor_day > max_date)begin
				kor_day = 8'd1;
			end
			
			//12 or 24
			if(h12or24 == 1'b1)begin
				if(kor_hour > 8'd11)begin
					HmodeChar <= 8'h50;							//P
					if(kor_hour > 8'd12)
						kor_hour = kor_hour - 8'd12;
				end
				else
					HmodeChar <= 8'h41;							//A	
			end														
			
			// watch 						
			case (index)											
				00 : out <= 8'h30 + tho_year;					
				01 : out	<=	8'h30 + hun_year;					
				02 : out	<=	8'h30 + ten_year;					
				03 : out	<=	8'h30 + one_year;					
				04 : out	<=	8'h2E;								//. 
				05 : out	<=	8'h30 + ten_month;
				06 : out	<=	8'h30 + one_month;
				07 : out	<=	8'h2E;								//.
				08 : out	<=	8'h30 + ten_day;
				09 : out	<=	8'h30 + one_day;
				
				10 : if(transfer_alarm > 0)
							out <= 8'h5B;							//[
						else
							out <= 8'h20;
							
				11 : if(transfer_alarm > 0) 
							out <= 8'h41;							//A
						else	
							out <= 8'h20;
							
				12 : if(transfer_alarm > 0) 
							out	<=	8'h5D;						//]
						else	
							out <= 8'h20;
							
				13 : if(calweek == 3'd0)
							out <= 8'h53;							//S
					  else if(calweek==3'd1) 
							out <= 8'h4D;							//M
					  else if(calweek==3'd2) 
							out <= 8'h54;							//T
					  else if(calweek==3'd3) 
							out <= 8'h57;							//W
					  else if(calweek==3'd4) 
							out <= 8'h54;							//T
					  else if(calweek==3'd5) 
							out <= 8'h46;							//F
					  else if(calweek==3'd6)
							out <= 8'h53;							//S
					  else 
							out <= 8'h20;
							
				14 : if(calweek == 3'd0)
							out <= 8'h55;							//U
					  else if(calweek==3'd1) 
							out <= 8'h4F;							//O
					  else if(calweek==3'd2) 
							out <= 8'h55;							//U
					  else if(calweek==3'd3)
							out <= 8'h45;							//E
					  else if(calweek==3'd4) 
							out <= 8'h48;							//H
					  else if(calweek==3'd5) 
							out <= 8'h52;							//R
					  else if(calweek==3'd6) 
							out <= 8'h41;							//A
					  else 
							out <= 8'h20;
							
				15 : if(calweek == 3'd0) 
							out <= 8'h4E;							//N
					  else if(calweek==3'd1) 
							out <= 8'h4E;							//N
					  else if(calweek==3'd2) 
							out <= 8'h45;							//E
					  else if(calweek==3'd3) 
							out <= 8'h44;							//D
					  else if(calweek==3'd4) 
							out <= 8'h55;							//U
					  else if(calweek==3'd5)
							out <= 8'h49;							//I
					  else if(calweek==3'd6)
							out <= 8'h54;							//T
					  else 
							out <= 8'h20;
							
							
				// line2
				16 : 	if(h12or24) 
							out <= HmodeChar;
						else 
							out <= 8'h20;
				17 : 	if(h12or24)	
							out <= 8'h4D;							//M
						else 	
							out <= 8'h20;
				18 : out <=	8'h20;
				19 : 	if(leap_year == 1'b1)					//'L'Leapyear
							out <= 8'h4C;							//L
						else
							out <= 8'h20;
				20 : 	if(leap_year == 1'b1)					//'Y'Leapyear
							out <= 8'h59;							//Y
						else
							out <= 8'h20;
							
				21 : out	<=	8'h20;
				22 : out	<=	8'h30 + ten_hour;
				23 : out	<=	8'h30 + one_hour;
				24 : out	<=	8'h3A;								//:
				25 : out	<=	8'h30 + ten_min;
				26 : out	<=	8'h30 + one_min;
				27 : out	<=	8'h3A;								//:
				28 : out	<=	8'h30 + ten_sec;
				29 : out	<=	8'h30 + one_sec;
				30 : out	<=	8'h20;
				31 : out	<=	8'h20;
				
			endcase
			
			ring_alarm	<= 1'b0;
			current_time	<=	{year,month,day,hour,min,sec};
			
			if(transfer_alarm > 0 && current_time >= transfer_alarm) begin
				ring_alarm	<= 1'b1;
				
				if (blink == 1) begin
					out 		<= 8'h20;
				end
			end
			
			else
				ring_alarm			<= 1'b0;
		end
	end
endmodule
				
				
				