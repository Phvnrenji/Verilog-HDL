 module booth_multiplier_module
(
	input CLK,
	input RSTn,
	input Start_Sig,
	input [7:0] A,
	input [7:0] B,
	
	output Done_Sig,
	output [15:0] Product,
	
	output [7:0] SQ_a,
	output [7:0] SQ_s,
	output [16:0] SQ_p
	);
	
	/*************************/ 
	
	reg [3:0] i;
	reg [7:0] a; //resultofA
	reg [7:0] s; //reverse result ofA
	reg [16:0] p; //operationregister
	reg [3:0] X;
	reg isDone;
	
	always@(posedge CLK or negedge RSTn)
	if(!RSTn)
		begin
		i<=4'd0;
		a<=8'd0;
		s<=8'd0;
		p <=17'd0;
		X<=4'd0;
		isDone<=1'b0;
		end
	else if(Start_Sig )
		case(i)
		
			0:
			begin a<=A;s<=(~A+1'b1);p<={8'd0,B,1'b0};i<=i+1'b1;end
			
			1:
			if(X==8) begin X<=4'd0;i<=i+4'd2;end
			else if( p[1:0]==2'b01) begin p<={p[16:9]+a,p[8:0]};i<=i+1'b1;end
			else if( p[1:0]==2'b10) begin p<={p[16:9]+s,p[8:0]};i<=i +1'b1;end
			else i<=i+1'b1;
			
			2:
			begin p<={p[16],p[16:1]};X<=X+1'b1;i<=i-1'b1;end
			
			3:
			begin isDone<=1'b1;i<=i+1'b1;end
			
			4:
			begin isDone<=1'b0;i<=4'd0;end
			
		endcase
		
		/*************************/
		
		assign Done_Sig=isDone;
		assign Product=p[16:1]; 
		
		/*************************/ 
		
		assign SQ_a=a;
		assign SQ_s=s;
		assign SQ_p=p;
		
		/**************************/
		
endmodule
