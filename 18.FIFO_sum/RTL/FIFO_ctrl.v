module FIFO_ctrl 
(
    input  wire         sys_clk, 
    input  wire         rst_n,       //异步复位 
    input  wire [7:0]   rx_data,     //串口接收到的数据
    input  wire         valid_flag,  //输入数据有效标志
    output wire [7:0]   tx_data,     //交给串口发送的数据           
    output wire         tx_en        //发送使能信号
);  
    
        
    parameter  row = 4;
    parameter  col = 5;
    
    
    
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
    
    
    reg wr_en1;
    reg wr_en2;
    
endmodule


