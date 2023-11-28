module FIFO_ctrl 
(
    input  wire         sys_clk, 
    input  wire         rst_n,       //异步复位 
    input  wire [7:0]   rx_data,     //串口接收到的数据
    input  wire         valid_flag,  //输入数据有效标志
    output wire [7:0]   tx_data,     //交给串口发送的数据           
    output wire         tx_en        //发送使能信号
);  
    
        
    parameter  row = 6;
    parameter  col = 5;
    //fifo1_cnt、fifo2_cnt计数范围：0 ~ col
    
    
    //辅助捕捉valid_flag信号的上升沿
    reg valid_reg1, valid_reg2;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            valid_reg1 <= 1'b0;
            valid_reg2 <= 1'b0;
        end
        else begin
            valid_reg1 <= valid_flag;
            valid_reg2 <= valid_reg1;
        end
    end
    
    
    //valid_rise表示valid_flag信号出现上升沿
    reg valid_rise;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            valid_rise <= 1'b0;
        else if((valid_reg1 == 1'b1) && (valid_reg2 == 1'b0))
            valid_rise <= 1'b1;
        else
            valid_rise <= 1'b0;
    end
    
    
    //FIFO1写使能
    reg wr_en1;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            wr_en1 <= 1'b0;
        else if(valid_rise == 1'b1)
            wr_en1 <= 1'b1;
        else
            wr_en1 <= 1'b0;
    end
    
    
    //FIFO1数据输入端口
    reg [7:0] dat_in1;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_in1 <= tx_data;
        else if(fifo1_full == 1'b1)
            dat_in1 <= dat_reg2;
        else
            dat_in1 <= tx_data;
    end
    

    //记录第一行数据写入FIFO1过程中的写入个数
    reg [2:0] fifo1_cnt;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo1_cnt <= 3'd0;
        else if((fifo1_cnt < col) && (wr_en1 == 1'b1))
            fifo1_cnt <= fifo1_cnt + 3'd1;
        else
            fifo1_cnt <= fifo1_cnt;
    end
    
    
    //fifo1_full拉高表示第一行数据已经全部写入FIFO1当中
    reg fifo1_full;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo1_full <= 1'b0;
        else if(fifo1_cnt == col)
            fifo1_full <= 1'b1;
        else
            fifo1_full <= fifo1_full;
    end
    
        
    //FIFO2写使能
    reg wr_en2;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            wr_en2 <= 1'b0;
        else if((fifo1_full == 1'b1) && (valid_rise == 1'b1))
            wr_en2 <= 1'b1;
        else
            wr_en2 <= 1'b0;
    end
    
    
    //FIFO2数据输入端口
    reg [7:0] dat_in2;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_in2 <= tx_data;
        else if(fifo2_full == 1'b1)
            dat_in2 <= dat_reg3;
        else
            dat_in2 <= tx_data;
    end
    
    
    //记录第二行数据写入FIFO2过程中的写入个数
    reg [2:0] fifo2_cnt;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo2_cnt <= 3'd0;
        else if((fifo1_cnt < col) && (wr_en2 == 1'b1))
            fifo2_cnt <= fifo2_cnt + 3'd1;
        else
            fifo2_cnt <= fifo2_cnt;
    end
    
    
    //fifo2_full拉高表示第二行数据已经全部写入FIFO2当中
    reg fifo2_full;
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo2_full <= 1'b0;
        else if(fifo2_cnt == col)
            fifo2_full <= 1'b1;
        else
            fifo2_full <= fifo2_full;
    end
    
    
    //loop_begin拉高表示，第一、二行的数据已经成功写入了FIFO1、FIFO中
    wire loop_begin;
    assign = fifo1_full & fifo2_full;
    
    
    
endmodule


