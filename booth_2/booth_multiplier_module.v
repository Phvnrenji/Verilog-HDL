 //booth算法改进版
 //将8个时钟消耗的移位运算压缩在一个步骤中
 //即将原先一次乘法运算的16个时钟，优化至8个时钟
 //testbench文件与原来一样
 
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
	//reg [3:0] X;
	reg [7:0] Diff_1;
	reg [7:0] Diff_2;
	reg isDone;
	
	always@(posedge CLK or negedge RSTn)
	if(!RSTn)
		begin
		i<=4'd0;
		a<=8'd0;
		s<=8'd0;
		p <=17'd0;
		//X<=4'd0;
		isDone<=1'b0;
		Diff_1<=8'd0;
		Diff_2<=8'd0;
		end
	else if(Start_Sig )
		case(i)
		
			0:
			begin 
				a<=A;
				s<=(~A+1'b1);
				p<={8'd0,B,1'b0};
				i<=i+1'b1;
			end
			
			1,2,3,4,5,6,7,8:
			begin
				
				Diff_1 = p[16:9]+a;//p空间前n位加上A，用于p[1:0]是2'b01的情况，这里是阻塞赋值，也就是说此时结果是“即使结果”，下同
				Diff_2 = p[16:9]+s;//p空间前n位加上B，用于p[1:0]是2'b10的情况
				
				if (p[1:0] == 2'b01)
					p <= { Diff_1[7], Diff_1, p[8:1]};//右移一位，高位补原来最高位值
				else if (p[1:0] == 2'b10)
					p <= { Diff_2[7], Diff_2, p[8:1]};
				else
					p <= {p[16], p[16:1]}; //2'b00,2'b11,除移位无操作
				
				i <= i+1'b1;
				
			end
			
			9:
			begin isDone<=1'b1;i<=i+1'b1;end
			
			10:
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
