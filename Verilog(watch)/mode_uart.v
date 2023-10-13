module	mode_uart	(
	clk,
	rst,
	sw_in,
	clk1sec,
	index,
	out);
	
	input				clk,rst;
	input	 [3:0]	sw_in;
	input	 [4:0]	index;
	input				clk1sec;
	
	output [7:0]	out;
	
	reg	 [7:0]	out;
	reg				blink;
	
	always @(posedge clk1sec) begin
		blink 	<=	1	-	blink;
	end
	
	always @(posedge clk or negedge rst)	begin
		if	(!rst) begin
			out		<= 8'h00;
		end
		case	(index)
			00	:	out	<= 8'h20;
			01	:	out	<= 8'h20;
			02	:	out	<= 8'h20;
			03	:	out	<= 8'h55;   					//U
			04	:	out	<= 8'h41; 						//A
			05	:	out	<= 8'h52; 						//R
			06	:	out	<= 8'h54; 						//T
			07	:	out	<= 8'h5F; 						
			08	:	out	<= 8'h4D;						//M
			09	:	out	<= 8'h4F;						//O	
			10	:	out	<= 8'h44;						//D
			11	:	out	<= 8'h45;						//E
			12	:	if(blink == 1'b1)						//.
						out	<= 8'h20;
					else
						out	<= 8'h2E;
			13	:	out	<= 8'h20;
			14	:	out	<= 8'h20;
			15	:	out	<= 8'h20;
			16	:	out	<= 8'h20;
			17	:	out	<= 8'h20;
			18	:	out	<= 8'h20;
			19	:	out	<= 8'h20;
			20	:	out	<= 8'h20;
			21	:	out	<= 8'h20;
			22	:	out	<= 8'h20;
			23	:	out	<= 8'h20;
			24	:	out	<= 8'h20;
			25	:	out	<= 8'h20;
			26	:	out	<= 8'h20;
			27	:	out	<= 8'h20;
			28	:	out	<= 8'h20;
			29	:	out	<= 8'h20;
			30	:	out	<= 8'h20;
			31	:	out	<= 8'h20;
		endcase
	end
	
endmodule
