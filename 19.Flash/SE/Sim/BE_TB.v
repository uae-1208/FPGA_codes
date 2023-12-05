`timescale  1ns/1ns

module BE_TB();

    reg       sys_clk;
    reg       rst_n;
    reg       touch_key;
    wire      MOSI;
    wire      cs_n;
    wire      sck;
    
     
    //时钟翻转
    always #10 sys_clk = ~sys_clk;
    
    
    initial begin
        sys_clk   <= 1'b1;
        rst_n     <= 1'b0;
        touch_key <= 1'b1;
        #20;
        rst_n <= 1'b1;
        //第一次BE
        #500;
        touch_key <= 1'b0;
        #500;
        touch_key <= 1'b1;
        //第一次BE未完成再按下触摸按键，观察是否会被打断
        #800;
        touch_key <= 1'b0;
        #500;
        touch_key <= 1'b1;
        //第一次BE未完成再按下触摸按键，观察模块是否可以连续BE
        #45_000;
        touch_key <= 1'b0;
        #500;
        touch_key <= 1'b1;
    end

    defparam memory.mem_access.initfile = "initmemory.txt";


    BE  BE
    (
        .sys_clk    (sys_clk   ), 
        .rst_n      (rst_n     ),      
        .touch_key  (touch_key ),  
        .MOSI       (MOSI      ),  
        .cs_n       (cs_n      ),  
        .sck        (sck       )  
    ); 

    m25p16  memory
    (
        .c          (sck    ),  //输入串行时钟,频率12.5Mhz,1bit
        .data_in    (MOSI   ),  //输入串行指令或数据,1bit
        .s          (cs_n   ),  //输入片选信号,1bit
        .w          (1'b1   ),  //输入写保护信号,低有效,1bit
        .hold       (1'b1   ),  //输入hold信号,低有效,1bit

        .data_out   (       )   //输出串行数据
    );        
    
endmodule