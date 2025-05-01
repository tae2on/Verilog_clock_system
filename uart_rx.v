/* UART receiver '8-N-1'(8 bit data, one one stop bit, and no parity bit.*/


module uart_rx #(parameter CLKS_PER_BIT, STOP_BIT)	(
	clk,
	rst,
	rx,
	data,
	rx_done);
	
	input				clk;
	input				rst;
	input				rx;
	output	[7:0] data;
	output			rx_done;

	//Declation of the status of the FSM
	parameter	 IDLE_RX	  = 2'b00;
	parameter	 START_RX  = 2'b01;
	parameter	 DATA_RX	  = 2'b10;
	parameter	 STOP_RX	  = 2'b11;
	
	reg	[7:0]  data;
	reg  			 rx_done;
	reg	[15:0] cnt_clk;
	reg	[2:0]	 bit_index;
	reg	[7:0]	 reg_data;
	reg	[1:0]	 state;
	reg	[1:0]	 next_state;

	initial begin 
		rx_done = 1'b0;
	end
	
	// FSM for UART Receiver
	always @(posedge clk or negedge rst) begin 
		if (!rst)
			state				<= IDLE_RX;
		else
			state				<= next_state;
		end
		
	always @ (*) begin 
		case (state)
			IDLE_RX : begin
				if (rx == 0)
					next_state		 	<= START_RX;
				else
					next_state			<= IDLE_RX;
				end
				
			// 시작 상태에서 Band 클록 주기의 중앙에서 수신 상태로 변경 여부 확인 
			START_RX : begin 
				if (cnt_clk == (CLKS_PER_BIT-1)/2) begin 
					if (rx == 0)
						next_state 	<= DATA_RX;
					else
						next_state 	<= IDLE_RX;
				end
				else
					next_state 	<= START_RX;
			end
				
			DATA_RX : begin 
				if (cnt_clk < CLKS_PER_BIT-1)
					next_state		<= DATA_RX;
				else begin 
					if (bit_index < 3'h7)
						next_state	<= DATA_RX;
					else
						next_state 	<= STOP_RX;
				end
			end
			
			STOP_RX : begin
				if (STOP_BIT == 2'd1)
					if (cnt_clk < ((CLKS_PER_BIT-1) + (CLKS_PER_BIT-1)/2))
						next_state		<= STOP_RX;
					else 					
						next_state		<= IDLE_RX;
				else
					if (cnt_clk < ((CLKS_PER_BIT-1)*2 + (CLKS_PER_BIT-1)/2))
						next_state		<= STOP_RX;
					else 					
						next_state		<= IDLE_RX;
			end
			
			default : next_state	<= IDLE_RX;
		endcase
	end

	// Counters for FSM
	always @ (posedge clk or negedge rst) begin 
		if (!rst) begin 
			cnt_clk						<= 0;
			bit_index					<= 0;
			reg_data						<= 0;
		end
		else begin 
			case(state)
				IDLE_RX : begin 
					cnt_clk				<= 0;
					bit_index			<= 0;
				end
			
				// 시작 상태에서 Baud 클록 주기의 중앙에서 수신기 Baud rate 카운터 리셋 
				START_RX : begin 
					if (cnt_clk == (CLKS_PER_BIT-1)/2 && rx== 0)
						cnt_clk			<= 0;
					else
						cnt_clk			<= cnt_clk + 1'b1;
				end
						
				DATA_RX : begin 
					if (cnt_clk < CLKS_PER_BIT-1)
							cnt_clk			<= cnt_clk + 1'b1;
					else begin 
							cnt_clk			<= 0;
							reg_data[bit_index]  <= rx;
							
							//Check if we have received all bits
							if (bit_index < 7)
								bit_index	<= bit_index + 1'b1;
							else
								bit_index 	<= 0;
					end
				end
					
					STOP_RX : begin 
						if(STOP_BIT == 2'd1)
							if (cnt_clk < ((CLKS_PER_BIT-1) + (CLKS_PER_BIT-1)/2))
								cnt_clk			<= cnt_clk + 1'b1;
							else
								cnt_clk			<= 0;
						else
							if (cnt_clk < ((CLKS_PER_BIT-1)*2 + (CLKS_PER_BIT-1)/2))
								cnt_clk			<= cnt_clk + 1'b1;
							else
								cnt_clk			<= 0;
					end
					
					default : cnt_clk 	<= cnt_clk;
				endcase
			end
		end
		
		//Outputs of UART Receiver
		always @(posedge clk or negedge rst) begin 
			if (!rst) begin 
				rx_done						<= 0;
				data							<= 0;
			end
			else begin 
				case (state)
					IDLE_RX  : rx_done <= 1'b0;
					
					START_RX : rx_done <= 1'b0;
					
					DATA_RX  : rx_done <= 1'b0;
					
					STOP_RX  : begin 
						if (STOP_BIT == 2'd1) begin			// Stop bit = 1 설정 시 정지 상태로 변경 즉시 수신된 데이터 출력 
							data				<= reg_data;
						if (cnt_clk == ((CLKS_PER_BIT-1)	+ (CLKS_PER_BIT-1)/2))
							rx_done 			<= 1'b1;
						else
							rx_done 			<= 1'b0;
					end
					else begin 
						data	<= reg_data;
						if (cnt_clk == ((CLKS_PER_BIT-1)*2 + (CLKS_PER_BIT-1)/2)) 	
							rx_done 			<= 1'b1;
						else
							rx_done 			<= 1'b0;
					end
				end
				
				default : data 		<= data;
			endcase
		end
	end
			
endmodule 