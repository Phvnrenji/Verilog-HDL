//使用print_task模块里封装好的task
module testcase();

//例化已经编写好的print_task.v，后面就可以调用其封装好的task了
print_task	print();
...
initial begin
if(...) print.error("Unexpected response\n");		//调用error任务
...
print.terminate;					//调用terminate任务
end
...
endmodule

