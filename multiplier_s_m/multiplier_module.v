module multiplier_module
(
	input CLK,
	input RSTn,

	input Start_Sig,
	input [7:0] Multiplicand,
	input [7:0] Multiplier,
	
	output Done_Sig,
	output [15:0] Product
);

	//寄存器	
	reg [1:0] i;
	reg [7:0] posMcand;
	reg [7:0] posMer;
	reg [15:0] posTemp;
	reg isNeg;
	reg isDone;


	always @ (posedge CLK or negedge RSTn)
		if (!RSTn)
		begin
			i <= 2'd0;
			posMcand <= 8'd0;
			posMer <= 8'd0;
			posTemp <= 16'd0;
			isNeg <= 1'b0;
			isDone <= 1'b0;
		end
		else if (Start_Sig)
			case(i)

				0:
				begin
					isNeg <= Multiplicand[7] ^ Multiplier[7];
					posMcand <= Multiplicand[7] ? (~Multiplicand + 1'b1) : Multiplicand;
					posMer <= Multiplier[7] ? (~Multiplier + 1'b1) : Multiplier;
					//posTemp <= 16'd0;								//重复？
					i <= i+ 1'b1;
				end

				1:
					if (posMer == 0) 
						i <= i + 1'b1;
					else 
					begin
						posTemp <= posTemp + posMcand;
						posMer <= posMer - 1'b1;
					end

				2:
				begin
					isDone <= 1'b1;
					i <= i + 1'b1;
				end

				3:
				begin
					isDone <= 1'b0;
					i <= 2'd0;
				end

			endcase

	/***********************/

	assign Done_Sig = isDone;
	assign Product = isNeg ? (~posTemp + 1'b1) : posTemp;

	/***********************/

endmodule










