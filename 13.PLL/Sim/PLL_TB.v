`timescale  1ns/1ns

module PLL_TB();

    reg sys_clk, rst_n;
    wire  clk_5MHz;
    wire  clk_10MHz;
    wire  clk_1MHz;
    wire  clk_180deg;
    wire  clk_20dc;
    wire  locked_sig1;
    wire  locked_sig2;
    
    //初始值
    initial sys_clk = 1'b1;
    initial rst_n = 1'b1;
        
    //sys_clk:模拟系统时钟，每10ns电平翻转一次，周期为20ns，频率为50Mhz
    always #10 sys_clk = ~sys_clk;
    


    PLL  PLL_inst
             (
                .sys_clk     (sys_clk    ), 
                .rst_n       (rst_n      ),      
                .clk_5MHz    (clk_5MHz   ),   
                .clk_10MHz   (clk_10MHz  ),  
                .clk_1MHz    (clk_1MHz   ),   
                .clk_180deg  (clk_180deg ), 
                .clk_20dc    (clk_20dc   ),   
                .locked_sig1 (locked_sig1),
                .locked_sig2 (locked_sig2) 
             );  
    
endmodule