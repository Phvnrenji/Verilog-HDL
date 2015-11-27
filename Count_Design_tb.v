`timescale 1ns/1ns

module Counter_Design_tb;

reg clk;
reg rst_n;
wire [3:0] cnt;
parameter PERIOD = 20;

Counter_Design	cd_testbench(
	.clk(clk),
	.rst_n(rst_n),
	.cnt(cnt)
);

initial
begin
	clk = 0;
	forever
		#(PERIOD/2)	clk = ~clk;
end

task task_reset
	begin
		rst_n = 0;
		repeat(2) @ (negedge clk);
		rst_n = 1;
	end
endtask

task task_sysinit;
	begin
	end
endtask

initial
begin
	task_sysinit;
	task_reset;
end

endmodule
