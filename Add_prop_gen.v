//4位加法器的传递和生成递归算法
//----------------------------
module Add_prop_gen(sum, c_out, a, b, c_in);
	input	[3:0]	a,b;
	input		c_in;
	output	[3:0]	sum;
	output		c_out;
	reg	[3:0]	carrychain;
	integer		i;
	wire	[3:0]	g = a & b;	//进位产生，连续赋值，按位与
	wire	[3:0]	p = a ^ b;	//进位产生，连续赋值，按位异或
always @ (a or b or c_in or p or g)	//事件“或”
begin:carry_generation
	integer	i;
	carrychain[0] = g[0] + (p[0] & c_in);
	for(i=1; i<=3; i=i+1)
	begin
		carrychain[i] = g[i] | (p[i] & carrychain[i-1]);
	end
end

	wire [4:0] shiftedcarry = {carrychain, c_in};
	wire [3:0] sum = p ^ shiftedcarry;
	wire c_out = shiftedcarry[4];
endmodule

