module switch(
		dip,
		sw,
		data,
		rx_done,
		out0,
		out1,
		out2,
		out3);
		
		input	[3:0]	dip;
		input	[3:0]	sw;
		input	[7:0] data;
		input			rx_done;
		
		output[3:0]	out0, out1, out2, out3;

		wire	[3:0]	sw;
		reg	[3:0]	out0, out1, out2, out3;
		reg	[3:0]	val;
		
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
					always @(dip or sw) begin
						if	(dip == 4'b0100) begin
							if	( val == 4'b0001 ) begin
								case(dip)
									4'b0001	:	out1	<=	sw;
									4'b0010	:	out2	<=	sw;
									4'b0100	:	out0	<=	sw;// mode 0 
									default	:	out0	<=	sw;
								endcase
							end
								
							else if	( val == 4'b0010 ) begin
								case(dip)
									4'b0001	:	out1	<=	sw;
									4'b0010	:	out2	<=	sw;
									4'b0100	:	out1	<=	sw;// mode 1
									default	:	out0	<=	sw;
								endcase
							end
							else if	( val == 4'b0100 ) begin
								case(dip)
									4'b0001	:	out1	<=	sw;
									4'b0010	:	out2	<=	sw;
									4'b0100	:	out2	<=	sw;// mode 2
									default	:	out0	<=	sw;
								endcase
							end
							else	if	( val == 4'b1000 ) begin
								case(dip)
									4'b0001	:	out1	<=	sw;
									4'b0010	:	out2	<=	sw;
									4'b0100	:	out3	<=	sw;// UART mode 3
									default	:	out0	<=	sw;
								endcase
							end
							else if (val == 4'b0000 )begin
								case(dip)
									4'b0001	:	out1	<=	sw;
									4'b0010	:	out2	<=	sw;
									4'b0100	:	out3	<=	sw;
									default	:	out0	<=	sw;
								endcase
							end
						end
						else begin
							case(dip)
								4'b0001	:	out1	<=	sw;
								4'b0010	:	out2	<=	sw;
								4'b0100	:	out3	<=	sw;
								default	:	out0	<=	sw;
							endcase
						end
					end

endmodule
	