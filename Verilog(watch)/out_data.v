module out_data(
		dip,
		watch,
		set,
		alarm,
		uart,
		data,
		rx_done,
		out);
		
		input	[3:0]	dip;
		input	[7:0]	watch, set, alarm, uart;
		input	[7:0] data;
		input			rx_done;
		
		output[7:0]	out;
		
		reg	[7:0]	out;
		reg	[3:0]	val;
		
		wire	[7:0]	watch, set, alarm, uart;
		
		

	  ///////////////////////////////////////////////////////////////////////////////			
				always @ (data) begin
					case(data)
						8'h21		:	val	<= 4'b0001; // data = (!)
						8'h40 	: 	val	<= 4'b0010; // data = (@)
						8'h23		:	val	<= 4'b0100; // data = (#)
						8'h24		: 	val	<= 4'b1000; // data = ($)
					endcase
				end
     ///////////////////////////////////////////////////////////////////////////////			

				always @(dip or watch or set or alarm or uart)begin
					if	(dip == 4'b0100) begin
						if		(val == 4'b0001) begin
							case(dip)
								4'b0001	:	out	<=	set;
								4'b0010	:	out	<=	alarm;
								4'b0100	:	out	<=	watch; 
								default	:	out	<=	watch;
							endcase
						end	
					
						else if 	(val == 4'b0010) begin
							case(dip)
								4'b0001	:  out	<= set;
								4'b0010	:	out	<=	alarm;
								4'b0100	:	out	<=	set; 
								default	:	out	<=	watch;
							endcase
						end
						else if 	(val == 4'b0100) begin
							case(dip)
								4'b0001	:  out	<= set;
								4'b0010	:	out	<=	alarm;
								4'b0100	:	out	<=	alarm;
								default	:	out	<=	watch;
							endcase
						end
						else if 	(val == 4'b1000) begin
							case(dip)
								4'b0001	: 	out	<= set;
								4'b0010	:	out	<=	alarm;
								4'b0100	:	out	<=	uart;
								default	:	out	<=	watch;
							endcase
						end
						else begin	// else if (val == 4'b0000) begin			
							case(dip)
								4'b0001	:	out	<=	set;
								4'b0010	:	out	<=	alarm;
								4'b0100	:	out	<=	uart;
								default	:	out	<=	watch;
							endcase
						end						
					end
					
					else  begin				
						case(dip)
							4'b0001	:	out	<=	set;
							4'b0010	:	out	<=	alarm;
							4'b0100	:	out	<=	uart;
							default	:	out	<=	watch;
						endcase
					end
				end

endmodule
