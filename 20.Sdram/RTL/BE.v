module BE 
(
    input  wire   sys_clk, 
    input  wire   rst_n,     //异步复位 
    input  wire   touch_key,      
    output reg    MOSI,        
    output reg    cs_n,        
    output reg    sck        
);  

    parameter WREN_instr = 8'h06;
    parameter BE_instr   = 8'hc7;
    
    reg touch_reg1, touch_reg2;
    reg touch_fall;                 //判断触摸按键是否被按下,按一下按键则模块工作一次  
    reg ena;                        //total_cnt的使能信号
    reg [3:0] total_cnt;            //节奏计数器       
    reg [2:0] c16_cnt;              //阶段计数器，每次total_cnt计数到15时，递增
    reg [1:0] clk_cnt;              //辅助sys_clk四分频
    reg [2:0] bit_cnt;              //记录已经发送的bit数目
    reg [7:0] WREN_reg;             //辅助发送WREN指令
    reg [7:0] BE_reg;               //辅助发送BE指令
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            touch_reg1 <= 1'b1;
            touch_reg2 <= 1'b1;
        end
        else begin
            touch_reg1 <= touch_key;
            touch_reg2 <= touch_reg1;
        end
    end
    //判断触摸按键是否被按下,按一下按键则模块工作一次  
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            touch_fall <= 1'b0;
        else if((touch_reg1 == 1'b0) && (touch_reg2 == 1'b1))
            touch_fall <= 1'b1;
        else 
            touch_fall <= 1'b0;
    end
    
    
    //total_cnt的使能信号
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            ena <= 1'b0;
        else if(touch_fall == 1'b1)
            ena <= 1'b1;
        else if(c16_cnt == 3'd7)
            ena <= 1'b0;
        else 
            ena <= ena;
    end
    
    
    //节奏计数器
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            total_cnt <= 4'd0;
        else if(ena == 1'b1)
            total_cnt <= total_cnt + 4'd1;
        else
            total_cnt <= 4'd0;
    end
    
    
    //阶段计数器，每次total_cnt计数到15时，递增
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            c16_cnt <= 3'd0;
        else if(ena == 1'b0)
            c16_cnt <= 3'd0;
        else if(total_cnt == 4'd15)
            c16_cnt <= c16_cnt + 3'd1;
        else
            c16_cnt <= c16_cnt;
    end
     
    
    //cs_n
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            cs_n <= 1'b1;
        else if((c16_cnt == 3'd0) && (total_cnt == 4'd12))
            cs_n <= 1'b0;
        else if((c16_cnt == 3'd3) && (total_cnt == 4'd4))
            cs_n <= 1'b1;
        else if((c16_cnt == 3'd3) && (total_cnt == 4'd12))
            cs_n <= 1'b0;
        else if((c16_cnt == 3'd6) && (total_cnt == 4'd4))
            cs_n <= 1'b1;
        else
            cs_n <= cs_n;
    end
    
    
    //辅助sys_clk四分频
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            clk_cnt <= 2'd0;
        else if((c16_cnt == 3'd1) || (c16_cnt == 3'd2) || (c16_cnt == 3'd4) || (c16_cnt == 3'd5))
            clk_cnt <= clk_cnt + 2'd1;
        else
            clk_cnt <= 2'd0;
    end
    
    
    //sck
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            sck <= 1'b1;
        else if(((c16_cnt==3'd1)||(c16_cnt==3'd2)||(c16_cnt==3'd4)||(c16_cnt==3'd5)) && (clk_cnt == 2'd0))
            sck <= 1'b0;
        else if(((c16_cnt==3'd1)||(c16_cnt==3'd2)||(c16_cnt==3'd4)||(c16_cnt==3'd5)) && (clk_cnt == 2'd2))
            sck <= 1'b1;
        else
            sck <= sck;
    end
    
    
    //记录已经发送的bit数目
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            bit_cnt <= 3'd0;
        else if(clk_cnt == 2'd3)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= bit_cnt;
    end
    
    
    //辅助发送WREN指令
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            WREN_reg <= WREN_instr;
        else if(ena == 1'b0)
            WREN_reg <= WREN_instr;
        else if(((c16_cnt == 3'd1)||(c16_cnt == 3'd2)) && (clk_cnt == 2'd3))   
            WREN_reg <= {WREN_reg[6:0], 1'b0};
        else
            WREN_reg <= WREN_reg;
    end
    
    
    //辅助发送BE指令
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            BE_reg <= BE_instr;
        else if(ena == 1'b0)
            BE_reg <= BE_instr;
        else if(((c16_cnt == 3'd4)||(c16_cnt == 3'd5)) && (clk_cnt == 2'd3))   
            BE_reg <= {BE_reg[6:0], 1'b0};
        else
            BE_reg <= BE_reg;
    end
    
    
    //MOSI
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            MOSI <= 1'b0;
        else if(((c16_cnt == 3'd1)||(c16_cnt == 3'd2)) && (clk_cnt == 2'd0))   
            MOSI <= WREN_reg[7];
        else if(((c16_cnt == 3'd4)||(c16_cnt == 3'd5)) && (clk_cnt == 2'd0))   
            MOSI <= BE_reg[7];
        else
            MOSI <= MOSI;
    end
    
endmodule


