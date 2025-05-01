/* bcd upcounter, carriage return */

module bcd_counter (
	clk,
	rst,
	en_sig,
	cnt_bcd);
	
	input				clk;
	input				rst;
	input				en_sig;
	output	[3:0]	cnt_bcd;
	
	// 0 -> 9 4bit
	reg		[3:0]	cnt_bcd;
	
	// enalbe signal bcd counter
	always @ (posedge clk or negedge rst) begin
		if(!rst)
			cnt_bcd		<= 0;
		else if (en_sig == 1'b1) begin
			if (cnt_bcd == 8)
				cnt_bcd	<= 0;
			else
				cnt_bcd	<= cnt_bcd + 1'b1;
			end
			else
				cnt_bcd	<= cnt_bcd;
			end
			
endmodule
