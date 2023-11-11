module RX 
(
    input  wire      sys_clk, 
    input  wire      rst_n,       //异步复位 
    input  wire      rx,          //串行数据接收端
    output wire      valid_flag,  //输出有效标志
    output reg [7:0] data_out     //并行数据输出端           
);  

    parameter Baud_9600 = 13'd5207;  //在50MHz的时钟下，计时1/9600s
    parameter Baud_115200 = 13'd434; //在50MHz的时钟下，计时1/115200s
    parameter read_cnt = Baud_115200 / 2;
    
    reg        re_reg1, re_reg2, re_reg3;  //reg1使异步的rx信号进行同步，reg2和reg3使避免亚稳态
    reg        start_flag;                 //开始标志位，接收到起始位后，拉高，滞后一个时钟周期
    reg        work_flag;                  //工作标志位，拉高代表模块开始接受串行数据
    reg [12:0] baud_cnt;                   //波特率计数器
    reg        read_flag;                  //读取标志位，拉高表示串行数据可以被读取
    reg [3:0]  bit_cnt;                    //接收比特计数器
    reg [7:0]  data_reg;                   //数据缓存

   
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            re_reg1 <= 1'b0;
            re_reg2 <= 1'b0;
            re_reg3 <= 1'b0;
        end
        else begin
            re_reg1 <= rx;
            re_reg2 <= re_reg1;
            re_reg3 <= re_reg2;
        end
    end
    
    
    //修改start_flag
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            start_flag <= 1'b0;
        else if((re_reg2 == 1'b0) && (re_reg3 == 1'b1) && (work_flag == 1'b0))
            start_flag <= 1'b1;
        else
            start_flag <= 1'b0;
    end
    
    
    //修改work_flag
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            work_flag <= 1'b0;
        else if(start_flag == 1'b1)
            work_flag <= 1'b1;
        else if(bit_cnt == 4'd9)            //接收到停止位baud，接收流程结束，work_flag拉低
            work_flag <= 1'b0;
        else
            work_flag <= work_flag;
    end
    
    
    //修改baud_cnt
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            baud_cnt <= 13'd0;
        else if(work_flag == 1'b1) begin 
            if(baud_cnt == Baud_115200)
                baud_cnt <= 13'd0;
            else 
                baud_cnt <= baud_cnt + 13'd1;
        end
        else   
            baud_cnt <= 13'd0;
    end
    
    
    //修改read_flag
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            read_flag <= 1'b0;
        else if(baud_cnt == read_cnt)       //在串行数据稳定时再读取，而不是跳变边沿
            read_flag <= 1'b1;
        else   
            read_flag <= 1'b0;
    end
    
    
    //修改bit_cnt
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            bit_cnt <= 4'd0;
        else if(work_flag == 1'b0)         //一字节串行数据接收完成，bit_cnt清零
            bit_cnt <= 4'd0;
        else if(read_flag == 1'b1)      
            bit_cnt <= bit_cnt + 4'd1;
        else   
            bit_cnt <= bit_cnt;
    end
    
    
    //修改data_reg
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            data_reg <= 8'd0;
        else if((4'd0 < bit_cnt) && (bit_cnt < 4'd9) && (read_flag == 1'b1))      
            data_reg <= {re_reg3, data_reg[7:1]};
        else   
            data_reg <= data_reg;
    end
    
    
    //修改data_out
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            data_out <= 8'd0;
        else if(bit_cnt == 4'd9)    
            data_out <= data_reg;
        else   
            data_out <= data_out;
    end
    
    
    //修改valid_flag
    assign valid_flag = ~work_flag;
    
endmodule


