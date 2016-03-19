`timescale 1ns/1ns
module	led_water_display
#(
	parameter LED_WIDTH = 8
)
(
	//global clock
	input			clk,
	input			rst_n,
	
	//user led output
	output reg [LED_WIDTH-1:0]	led_data
);

//----------------------------------------------------
//localparam DELAY_TOP = 24'h3f_ffff;
localparam DELAY_TOP = 24'hf;
reg [23:0]	delay_cnt;
always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)
		delay_cnt <= 0;
	else if(delay_cnt < DELAY_TOP)
		delay_cnt <= delay_cnt + 1'b1;
	else
		delay_cnt <= 0;
end
wire delay_done = (delay_cnt == DELAY_TOP) ? 1'b1 : 1'b0;

//----------------------------------------------------
//Generate 14 cycles
reg [3:0] led_state;
always @ (posedge clk @ negedge rst_n)
begin
	if(!rst_n)
		led_state <= 0;
	else if(delay_done)
	begin
		if(led_state < 4'hD)
			led_state <= led_state + 1'b1;
		else
			led_state <= 4'd0;
	end
	else
		led_state <= led_state;
end

//-----------------------------------------------------
//Display Water LED
always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)
		led_data <= 0;
	else
		case(led_state)
			4'h0:		led_data <= 8'b10000000;
			4'h1:		led_data <= 8'b01000000;
			4'h2:		led_data <= 8'b00100000;
			4'h3:		led_data <= 8'b00010000;
			4'h4:		led_data <= 8'b00001000;
			4'h5:		led_data <= 8'b00000100;
			4'h6:		led_data <= 8'b00000010;
			4'h7:		led_data <= 8'b00000001;
			4'h8:		led_data <= 8'b00000010;
			4'h9:		led_data <= 8'b00000100;
			4'hA:		led_data <= 8'b00001000;
			4'hB:		led_data <= 8'b00010000;
			4'hC:		led_data <= 8'b00100000;
			4'hD:		led_data <= 8'b01000000;
			default:	led_data <= 8'b10000000;
		endcase
end

endmodule

