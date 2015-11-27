//封装error,warning,fatal,terminate等任务
//---------------------------------------
module print_task();

//显示warning报告，同时包含显示当前时间和警告内容（由用户输入）
task warning;
	input [80*8:1] msg;
	begin
		$write("WARNING at %t: %s", $ time, msg);
	end
endtask

//显示error报告
task error;
	input [80*8:1] msg;
	begin
		$write("-ERROR- at %t: %s", $ time, msg);
	end
endtask

//显示fatal报告
task fatal;
	input [80*8:1] msg;
	begin
		$write("*FATAL* at %t: %s", $ time, msg);
	terminate;
	end
endtask

//显示warning报告，同时包含显示当前时间和结束信息（改任务自动生成）
task terminate;
	begin
		$write("Simulation completed\n");
		$finish;
	end
endtask

endmodule

