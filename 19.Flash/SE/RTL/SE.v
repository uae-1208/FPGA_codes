module SE 
(
    input  wire   sys_clk, 
    input  wire   rst_n,     //异步复位 
    input  wire   ena_rise,  //输入一个脉冲则工作一次    
    output reg    MOSI,        
    output reg    cs_n,        
    output reg    sck        
);  

    parameter WREN_instr = 8'h06;
    parameter SE_instr   = 8'hd8;
    parameter addr       = 24'hab_cd_ef;
    
    reg ena_reg;            //延迟ena_rise一个时钟周期
    reg ena_flag;           //ena_rise出现上升沿标志
    reg ena;                //total_cnt的使能信号
    reg [3:0] total_cnt;    //节奏计数器       
    reg [4:0] c16_cnt;      //阶段计数器，每次total_cnt计数到15时，递增
    reg [1:0] clk_cnt;      //辅助sys_clk四分频
    reg [2:0] bit_cnt;      //记录已经发送的bit数目
    reg [7:0] dat_reg;             

    
    //ena_reg
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            ena_reg <= 1'b0;
        else 
            ena_reg <= ena_rise;
    end
    //ena_flag
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            ena_flag <= 1'b0;
        else if((ena_rise == 1'b1) && (ena_reg == 1'b0))
            ena_flag <= 1'b1;
        else
            ena_flag <= 1'b0;
    end
    
    
    //total_cnt的使能信号
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            ena <= 1'b0;
        else if(ena_flag == 1'b1)
            ena <= 1'b1;
        else if(c16_cnt == 4'd13)
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
            c16_cnt <= 4'd0;
        else if(ena == 1'b0)
            c16_cnt <= 4'd0;
        else if(total_cnt == 4'd15)
            c16_cnt <= c16_cnt + 4'd1;
        else
            c16_cnt <= c16_cnt;
    end
     
    
    //cs_n
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            cs_n <= 1'b1;
        else if((c16_cnt == 4'd0) && (total_cnt == 4'd12))
            cs_n <= 1'b0;
        else if((c16_cnt == 4'd3) && (total_cnt == 4'd4))
            cs_n <= 1'b1;
        else if((c16_cnt == 4'd3) && (total_cnt == 4'd12))
            cs_n <= 1'b0;
        else if((c16_cnt == 4'd12) && (total_cnt == 4'd4))
            cs_n <= 1'b1;
        else
            cs_n <= cs_n;
    end
    
    
    //辅助sys_clk四分频
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            clk_cnt <= 2'd0;
        //c16_cnt为1、2以及4-11
        else if((c16_cnt == 4'd1) || (c16_cnt == 4'd2) || ((4'd4 <= c16_cnt)&&(c16_cnt <= 4'd11)))
            clk_cnt <= clk_cnt + 2'd1;
        else
            clk_cnt <= 2'd0;
    end
    
    
    //sck
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            sck <= 1'b1;
        else if(((c16_cnt==4'd1)||(c16_cnt==4'd2)||((4'd4<=c16_cnt)&&(c16_cnt<=4'd11))) && (clk_cnt == 2'd0))
            sck <= 1'b0;
        else if(((c16_cnt==4'd1)||(c16_cnt==4'd2)||((4'd4<=c16_cnt)&&(c16_cnt<=4'd11))) && (clk_cnt == 2'd2))
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
    
    
    //辅助MOSI输出
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_reg <= WREN_instr;
        //写使能指令
        else if((c16_cnt == 4'd0) && (clk_cnt == 2'd0))
            dat_reg <= WREN_instr;
        //扇区擦除指令
        else if((c16_cnt == 4'd3) && (clk_cnt == 2'd0))
            dat_reg <= SE_instr;
        //擦除地址高八位
        else if((c16_cnt == 4'd5) && (clk_cnt == 2'd3))
            dat_reg <= addr[23:16];
        //擦除地址中八位
        else if((c16_cnt == 4'd7) && (clk_cnt == 2'd3))
            dat_reg <= addr[15:8];
        //擦除地址低八位
        else if((c16_cnt == 4'd9) && (clk_cnt == 2'd3))
            dat_reg <= addr[7:0];
        else if(clk_cnt == 2'd3)   
            dat_reg <= {dat_reg[6:0], 1'b0};
        else
            dat_reg <= dat_reg;
    end     
    
    
    //MOSI
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            MOSI <= 1'b0;
        else if(clk_cnt == 2'd0)
            MOSI <= dat_reg[7];
        else
            MOSI <= MOSI;
    end
    
endmodule


