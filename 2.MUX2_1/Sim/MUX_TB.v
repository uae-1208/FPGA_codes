`timescale  1ns/1ns


module MUX_TB();

    reg in1, in2, sel;
    wire out;
    
    //初始值为低电平
    initial in1 <= 1'b0;
    initial in2 <= 1'b0;
    initial sel <= 1'b0;
    
    initial begin
    //设置显示的时间格式,此处表示的是(打印时间单位为纳秒,小数点后打印的小数位为0位,时间值后打印的字符串为“ns”,打印的最小数量字符为6个)
    $timeformat(-9, 0, "ns", 6);    
    //只要监测的变量(时间、in1, in2, sel, out)发生变化,就会打印出相应的信息
    $monitor("@time %t: in1=%b in2=%b sel=%b out=%b", $time, in1, in2, sel, out);   
    end
    
    //产生随机电平
    always #10 in1 <= {$random} % 2;
    always #10 in2 <= {$random} % 2;
    always #10 sel <= {$random} % 2;

    MUX2_1 MUX_inst
        (
        .in1 (in1),
        .in2 (in2),
        .sel (sel),
        
        .out (out)
        );

endmodule