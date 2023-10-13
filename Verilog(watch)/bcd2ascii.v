/* BCD to ASCII */

module bcd2ascii (
	clk,
	rst,
	cnt_bcd,
	bcd_ascii);
	
	input				clk;
	input				rst;
	input		[3:0]	cnt_bcd;
	output	[7:0]	bcd_ascii;
	
	wire		[3:0]	cnt_bcd;
	reg		[7:0]	bcd_ascii;
	
	// Convert BCD to ASCII
	always @ (posedge clk or negedge rst) begin
		if (!rst)
			bcd_ascii <= 8'h00; //NULL
		else begin
			case(cnt_bcd)
				4'h0		:	bcd_ascii <= 8'h57; // W
				4'h1		:	bcd_ascii <= 8'h61; // a
				4'h2		:	bcd_ascii <= 8'h6B; // k
				4'h3		:	bcd_ascii <= 8'h65; // e
				4'h4		:	bcd_ascii <= 8'h20; // space
				4'h5		:	bcd_ascii <= 8'h55; // U
				4'h6		:	bcd_ascii <= 8'h70; // p
				4'h7		:	bcd_ascii <= 8'h21; // !
				4'h8		:	bcd_ascii <= 8'h0D; // CR(Carriage Return)
				default	:	bcd_ascii <= 8'h00; // NULL
			endcase
		end
	end
	
endmodule
