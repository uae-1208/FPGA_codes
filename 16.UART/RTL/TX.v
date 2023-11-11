module TX 
(
    input  wire      sys_clk, 
    input  wire      rst_n,       //异步复位 
    input  wire[7:0] data_in,     //并行数据接收端
    input  wire      tx_en,       //发送使能信号，上升沿代表TX模块开始发送此瞬间的data_in
    output wire      busy_flag,   //忙碌标志，输出高电平代表此时正在串行发送数据，tx_en出现上升沿也没用
    output reg       tx           //串行数据输出端           
);  

    parameter Baud_9600 = 13'd53;//13'd5207;  //在50MHz的时钟下，计时1/9600s
    parameter Baud_115200 = 13'd434;//在50MHz的时钟下，计时1/115200s
    
//    reg        en_reg1, en_reg2, en_reg3;  //reg1使异步的使能信号进行同步，reg2和reg3使避免亚稳态
    reg        en_reg;                     //与sys_clk必须是同步的
    reg        start_flag;                 //开始标志位，接收到使能信号上升沿后拉高，滞后一个时钟周期
    reg        work_flag;                  //工作标志位，拉高代表模块开始发送串行数据的流程
    reg [12:0] baud_cnt;                   //波特率计数器
    reg [3:0]  bit_cnt;                    //发送比特计数器
    reg [7:0]  data_reg;                   //数据缓存



   
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            en_reg <= 1'b0;
        else 
            en_reg <= tx_en;
    end
    
    
    //修改start_flag
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            start_flag <= 1'b0;
        else if((tx_en == 1'b1) && (en_reg == 1'b0) && (busy_flag == 1'b0))
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
        else if(bit_cnt == 4'd9)            //开始发停止位时，发送流程结束，work_flag拉低
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
    
    
    //修改bit_cnt
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            bit_cnt <= 4'd0;
        else if(work_flag == 1'b0)         //一字节串行数据发送完成，bit_cnt清零
            bit_cnt <= 4'd0;
        else if(baud_cnt == Baud_115200)  
            bit_cnt <= bit_cnt + 4'd1;
        else   
            bit_cnt <= bit_cnt;
    end
    
    
    //修改data_reg
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            data_reg <= 8'd0;
        else if(start_flag == 1'b1)  
            data_reg <= data_in;
        else if(baud_cnt == Baud_115200)      
            data_reg <= {1'b0, data_reg[7:1]};
        else   
            data_reg <= data_reg;
    end


    //修改tx
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            tx <= 1'b1;
        else if(start_flag == 1'b1)     //起始位
            tx <= 1'b0;
        else if((4'd0 <= bit_cnt) && (bit_cnt < 4'd8) && (baud_cnt == Baud_115200)) 
            tx <= data_reg[0];
        else if((bit_cnt == 4'd8) && (baud_cnt == Baud_115200))      //停止位
            tx <= 1'b1;
        else
            tx <= tx;
    end


    //修改busy_flag
    assign busy_flag = work_flag;
endmodule


