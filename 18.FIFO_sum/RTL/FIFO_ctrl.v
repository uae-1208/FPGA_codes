module FIFO_ctrl 
(
    input  wire         sys_clk, 
    input  wire         rst_n,       //异步复位 
    input  wire [7:0]   rx_data,     //串口接收到的数据
    input  wire         valid_flag,  //输入数据有效标志
    output reg  [7:0]   tx_data,     //交给串口发送的数据           
    output wire         tx_en        //发送使能信号
);  
    
        
    //fifo1_cnt、fifo2_cnt计数范围：0 ~ col
    parameter  row = 5;
    parameter  col = 5;
    reg       valid_reg1, valid_reg2; //辅助捕捉valid_flag信号的上升沿
    reg       valid_rise;             //valid_rise表示valid_flag信号出现上升沿
    reg       wr_en1, wr_en2;         //FIFO写使能
    reg [7:0] dat_in1, dat_in2;       //FIFO数据输入端口
    reg [2:0] fifo1_cnt;              //记录第一行数据写入FIFO1过程中的写入个数
    reg [2:0] fifo2_cnt;              //记录第二行数据写入FIFO2过程中的写入个数
    reg       fifo1_full;             //fifo1_full拉高表示第一行数据已经全部写入FIFO1当中
    reg       fifo2_full;             //fifo2_full拉高表示第二行数据已经全部写入FIFO2当中
    wire      loop_begin;             //loop_begin拉高表示，第一、二行的数据已经成功写入了FIFO1、FIFO中
    reg       rd_en1, rd_en2;         //FIFO读使能
    reg [7:0] dat_reg1;               //暂存每三行数据中的第一行数据
    reg [7:0] dat_reg2;               //暂存每三行数据中的第二行数据
    reg [7:0] dat_reg3;               //暂存每三行数据中的第三行数据
    reg [2:0] sum_cnt;                //给FIFO读取和计算3个数据的和留下一些时间缓冲    
    wire[7:0] sum;
    wire[7:0] dat_out1;
    wire[7:0] dat_out2;


    
    //辅助捕捉valid_flag信号的上升沿
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            //复位值为1是因为valid_flag的复位值也为1
            valid_reg1 <= 1'b1;
            valid_reg2 <= 1'b1;
        end
        else begin
            valid_reg1 <= valid_flag;
            valid_reg2 <= valid_reg1;
        end
    end
    
    
    //valid_rise表示valid_flag信号出现上升沿
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            valid_rise <= 1'b0;
        else if((valid_reg1 == 1'b1) && (valid_reg2 == 1'b0))
            valid_rise <= 1'b1;
        else
            valid_rise <= 1'b0;
    end
    
    
    //FIFO1写使能
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            wr_en1 <= 1'b0;
        else if((fifo1_full == 1'b0) && (valid_rise == 1'b1))
            wr_en1 <= 1'b1;
        else if((loop_begin == 1'b1) && (sum_cnt == 3'd7))
            wr_en1 <= 1'b1;
        else
            wr_en1 <= 1'b0;
    end
    
    
    //FIFO1数据输入端口
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_in1 <= rx_data;
        else if(fifo1_full == 1'b1)
            dat_in1 <= dat_reg2;
        else
            dat_in1 <= rx_data;
    end
    

    //记录第一行数据写入FIFO1过程中的写入个数
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo1_cnt <= 3'd0;
        else if((fifo1_cnt < col) && (wr_en1 == 1'b1))
            fifo1_cnt <= fifo1_cnt + 3'd1;
        else
            fifo1_cnt <= fifo1_cnt;
    end
    
    
    //fifo1_full拉高表示第一行数据已经全部写入FIFO1当中
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo1_full <= 1'b0;
        else if(fifo1_cnt == col)
            fifo1_full <= 1'b1;
        else
            fifo1_full <= fifo1_full;
    end
    
        
    //FIFO2写使能
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            wr_en2 <= 1'b0;
        else if((fifo1_full == 1'b1) && (loop_begin == 1'b0) && (valid_rise == 1'b1))
            wr_en2 <= 1'b1;
        else if((loop_begin == 1'b1) && (sum_cnt == 3'd7))
            wr_en2 <= 1'b1;
        else
            wr_en2 <= 1'b0;
    end
    
    
    //FIFO2数据输入端口
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_in2 <= rx_data;
        else if(fifo2_full == 1'b1)
            dat_in2 <= dat_reg3;
        else
            dat_in2 <= rx_data;
    end
    
    
    //记录第二行数据写入FIFO2过程中的写入个数
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo2_cnt <= 3'd0;
        else if((fifo2_cnt < col) && (wr_en2 == 1'b1))
            fifo2_cnt <= fifo2_cnt + 3'd1;
        else
            fifo2_cnt <= fifo2_cnt;
    end
    
    
    //fifo2_full拉高表示第二行数据已经全部写入FIFO2当中
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            fifo2_full <= 1'b0;
        else if(fifo2_cnt == col)
            fifo2_full <= 1'b1;
        else
            fifo2_full <= fifo2_full;
    end
    
    
    //loop_begin拉高表示，第一、二行的数据已经成功写入了FIFO1、FIFO中
    assign loop_begin = fifo1_full & fifo2_full;
    
    
        
    //FIFO1读使能
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            rd_en1 <= 1'b0;
        else if((loop_begin == 1'b1) && (valid_rise == 1'b1))
            rd_en1 <= 1'b1;
        else
            rd_en1 <= 1'b0;
    end
    
    
    //FIFO2读使能
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            rd_en2 <= 1'b0;
        else if((loop_begin == 1'b1) && (valid_rise == 1'b1))
            rd_en2 <= 1'b1;
        else
            rd_en2 <= 1'b0;
    end
    
    
    //暂存每三行数据中的第一行数据
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_reg1 <= 8'd0;
        else if(loop_begin == 1'b1)
            dat_reg1 <= dat_out1;
        else
            dat_reg1 <= dat_reg1;
    end
    
    
    //暂存每三行数据中的第二行数据
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_reg2 <= 8'd0;
        else if(loop_begin == 1'b1)
            dat_reg2 <= dat_out2;
        else
            dat_reg2 <= dat_reg2;
    end
    
    
    //暂存每三行数据中的第三行数据
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            dat_reg3 <= 8'd0;
        else if((loop_begin == 1'b1) && (valid_rise == 1'b1))
            dat_reg3 <= rx_data;
        else
            dat_reg3 <= dat_reg3;
    end
    
    
    //给FIFO读取和计算3个数据的和留下一些时间缓冲
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            sum_cnt <= 3'd0;
        else if(sum_cnt == 3'd0) begin
            if((loop_begin == 1'b1) && (valid_rise == 1'b1))
                sum_cnt <= sum_cnt + 3'd1;
            else
                sum_cnt <= sum_cnt;
        end else
            sum_cnt <= sum_cnt + 3'd1;
    end
        
    
    assign sum = dat_reg1 + dat_reg2 + dat_reg3;
    assign tx_en = (sum_cnt == 3'd7);
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            tx_data <= 8'd0;
        else if(sum_cnt == 3'd7)
            tx_data <= sum;
        else
            tx_data <= tx_data;
    end
    
    
    FIFO1	FIFO1_inst (
                .clock ( sys_clk ),
                .data  ( dat_in1 ),
                .rdreq ( rd_en1  ),
                .wrreq ( wr_en1  ),
                .q     ( dat_out1)
            );
       
    FIFO2	FIFO2_inst (
                .clock ( sys_clk ),
                .data  ( dat_in2 ),
                .rdreq ( rd_en2  ),
                .wrreq ( wr_en2  ),
                .q     ( dat_out2)
            );
            
endmodule


