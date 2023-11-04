module PLL 
(
    input  wire sys_clk, 
    input  wire rst_n,         //异步复位     
    output wire clk_5MHz,      //PLL1输出：5MHz    
    output wire clk_10MHz,     //PLL2输出0：10MHz   
    output wire clk_1MHz,      //PLL2输出1：1MHz 
    output wire clk_180deg,    //PLL2输出2：5MHz,180°相移  
    output wire clk_20dc,      //PLL2输出3：5MHz,20%占空比    
    output wire locked_sig1,   //PLL1锁定信号     
    output wire locked_sig2    //PLL2锁定信号     
);  
         
     
    PLL1	PLL1_inst (
                .inclk0 (sys_clk),
                .c0     (clk_5MHz),
                .locked (locked_sig1)
            );

    PLL2	PLL2_inst (
                .inclk0 (clk_5MHz),
                .c0     (clk_10MHz),
                .c1     (clk_1MHz),
                .c2     (clk_180deg),
                .c3     (clk_20dc),
                .locked (locked_sig2)
            );
        
    
endmodule

