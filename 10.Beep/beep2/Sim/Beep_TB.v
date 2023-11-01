`timescale  1ns/1ns

module Beep_TB();

    reg sys_clk, rst_n;
    reg [3:0] key;
    wire Beep;
    wire [3:0] led;
    
    //初始值
    initial begin
        sys_clk <= 1'b1;
        rst_n <= 1'b0;
        key <= 4'b0000;
        #50
        rst_n <= 1'b1;
        #500
        rst_n <= 1'b0;
        #550
        rst_n <= 1'b1;
        end
    
    //时钟翻转
    always #10 sys_clk <= ~sys_clk;

    //产生随机电平
    always #500 key[0] <= {$random} % 2;
    always #500 key[1] <= {$random} % 2;
    always #500 key[2] <= {$random} % 2;
    always #500 key[3] <= {$random} % 2;


    Beep    Beep_inst
            (
                .sys_clk (sys_clk), 
                .rst_n   (rst_n),     
                .key     (key),     
                .beep    (beep),
                .led     (led)
            );
    
endmodule