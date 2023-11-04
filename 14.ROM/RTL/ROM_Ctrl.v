module ROM_Ctrl 
(
    input  wire      sys_clk, 
    input  wire      rst_n,      //异步复位 
    input  wire      key_flag,   //电容按键按下标志
    output reg [7:0] addr        //ROM的读取地址     
);  
   
    //计数器最大值（0.1s）
    parameter  cnt_max = 24'd4_999_999; 
    reg [23:0] cnt_val;          //计数值
    reg        cnt_flag;         //计数标志位
    reg [1:0]  key_record;
    reg        chg_flag;         //允许ROM地址变化的标注位
    
    //4种状态：开始递增，停止递增，跳转到addr=100再递增，跳转到addr=200再递增
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            key_record <= 2'd0;
        else if(key_flag == 1'b1) 
            key_record <= key_record + 2'd1;
        else
            key_record <= key_record;
    end
    
    
    //计数
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_val <= 24'd0;
            cnt_flag <= 1'd0;
        end
        else if(cnt_val == cnt_max) begin
            cnt_val <= 24'd0;
            cnt_flag <= 1'd1;
        end
        else begin
            cnt_val <= cnt_val + 24'd1;
            cnt_flag <= 1'd0;
        end
    end
    
    
    //计数标志，更改ROM地址
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            addr <= 8'b0000_0000;
            chg_flag <= 1'b1;
        end
        else if(key_flag == 1'b1) 
            case(key_record)
                2'b00: chg_flag <= 1'b1;    //开始递增
                2'b01: chg_flag <= 1'b0;    //停止递增
                2'b10: begin                //跳转到addr=100再递增
                        chg_flag <= 1'b1; 
                        addr <= 8'd100;
                       end
                2'b11: begin                //跳转到addr=200再递增
                        chg_flag <= 1'b1; 
                        addr <= 8'd200;
                       end
            endcase
        else if(cnt_flag == 1'b1 && chg_flag == 1'b1) 
            addr <= addr + 8'd1;
        else
            addr <= addr;
    end
    
endmodule

