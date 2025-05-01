module watch_time(
						clk,
						clk1sec,
						rst,
						transfer_time,
						set_time,
						year,
						month,
						day,
						hour,				
						min,	
						sec,
						week,
						max_date);
	
	input				 clk,rst;
	input				 clk1sec;
	input				 set_time;
	input		[51:0] transfer_time;
	
	output	[13:0] year;
	output	[7:0]	 month;
	output	[7:0]	 day;
	output	[7:0]	 hour;
	output	[7:0]	 min;
	output	[7:0]	 sec;
	output	[2:0]	 week;
	output	[4:0]	 max_date;
	
	reg		[13:0] year;
	reg		[7:0]	 month;
	reg		[7:0]	 day;
	reg		[7:0]	 hour;
	reg		[7:0]	 min;
	reg		[7:0]	 sec;
	reg		[7:0]	 max_date;
	reg		[2:0]	 week;
	reg		[8:0]	 sum_day;
	
	wire				 set_time;
	wire		[51:0] transfer_time;
	wire 				 leap_year;
	
	always @ (*) begin
		case	(month)
			1	:	sum_day	<= 8'd0;
			2	:	sum_day	<= 8'd31; 	// +31
			3	:	sum_day	<= 8'd59; 	// +28
			4	:	sum_day	<= 8'd90; 	// +31	
			5	:	sum_day	<= 8'd120;	// +30
			6	:	sum_day	<= 8'd151;	// +31
			7	:	sum_day	<= 8'd181;	// +30
			8	:	sum_day	<= 8'd212;	// +31
			9	:	sum_day	<= 8'd243;	// +31
			10	:	sum_day	<= 8'd273;	// +30
			11	:	sum_day	<= 8'd304;	// +31
			12	:	sum_day	<= 8'd334;	// +30
		endcase
	end
	
	
	assign leap_year = (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0) ? 1'b1 : 1'b0;
	
	always @ (*) begin
		if ( (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0)  &&	month	>	3)
			week <= ((((year-1)*365) + (((year-1)/4) - ((year-1)/100) + ((year-1)/400))) + sum_day + 1 + day) % 7;
		
		else
			week <= ((((year-1)*365) + (((year-1)/4) - ((year-1)/100) + ((year-1)/400))) + sum_day + day) % 7;
	end
	
	always @(*)
		case(month)
				8'd1, 8'd3, 8'd5, 8'd7, 8'd8, 8'd10, 8'd12 :	
						max_date	<= 8'd31;
				8'd2 :	
						max_date	<= 8'd28 + leap_year;
				8'd4, 8'd6, 8'd9, 8'd11	:
						max_date <=	8'd30;
				default :
						max_date <= 0;
		endcase

		
	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
			year		<=	14'd2022;
			month		<=	8'd06;
			day		<=	8'd09;
			hour		<=	8'd11;
			min		<=	8'd30;
			sec		<=	8'd30;
		end
		
		else if(set_time == 1) begin
			year 		<= year;
			month		<= month;
			day		<= day;
			hour		<= hour;
			min		<=	min;
			sec		<=	sec;
			{year, month, day, hour, min, sec} <= transfer_time;
		end
		
		else begin
			year 		<= year;
			month		<= month;
			day		<= day;
			hour		<= hour;
			min		<=	min;
			sec 		<=	sec;
			
			if (clk1sec == 1) begin
				casez ({year, month, day, hour, min, sec})
					{14'd9999, 8'd12, max_date, 8'd23, 8'd59, 8'd59} : begin
						year		<= 1'd1;
						month 	<= 1'd1;
						day		<= 1'd1;
						hour		<=	1'd0;
						min		<=	1'd0;
						sec		<=	1'd0;
					end
					
					{14'dz, 8'd12, 8'd1, 8'd23, 8'd59, 8'd59} : begin
						year		<= year + 1'd1;
						month 	<= 1'd1;
						day		<= 1'd1;
						hour		<=	1'd0;
						min		<=	1'd0;
						sec		<=	1'd0;
					end
					
					{14'dz, 8'd12, max_date, 8'd23, 8'd59, 8'd59} : begin
						year		<= year + 1'd1;
						month 	<= 1'd1;
						day		<= 1'd1;
						hour		<=	1'd0;
						min		<=	1'd0;
						sec		<=	1'd0;
					end
					
					{14'dz, 8'dz, max_date, 8'd23, 8'd59, 8'd59} : begin
						year		<= year;
						month 	<= month + 1'd1;
						day		<= 1'd1;
						hour		<=	1'd0;
						min		<=	1'd0;
						sec		<=	1'd0;
					end
					
					{14'dz, 8'dz, 8'dz, 8'd23, 8'd59, 8'd59} : begin
						year		<= year; 
						month 	<= month;
						day		<= day + 1'd1;
						hour		<=	1'd0;
						min		<=	1'd0;
						sec		<=	1'd0;
					end
					
					{14'dz, 8'dz, 8'dz, 8'dz, 8'd59, 8'd59} : begin
						year		<= year; 
						month 	<= month;
						day		<= day;
						hour		<=	hour + 1'd1;
						min		<=	1'd0;
						sec		<=	1'd0;
					end
					
					{14'dz, 8'dz, 8'dz, 8'dz, 8'dz, 8'd59} : begin
						year		<= year; 
						month 	<= month;
						day		<= day;
						hour		<=	hour;
						min		<=	min + 1'd1;
						sec		<=	1'd0;
					end
					
					default : begin
						year		<= year; 
						month 	<= month;
						day		<= day;
						hour		<=	hour;
						min		<=	min;
						sec		<=	sec + 1'd1;
					end
				endcase
			end
		end
	end
endmodule
