module RAM_Ctrl 
(
    input  wire      sys_clk, 
    input  wire      rst_n,      //异步复位 
    input  wire      key_flag,   //电容按键按下标志
    output wire      rden,       //RAM读使能信号
    output wire      wren,       //RAM写使能信号
    output reg [7:0] data_in,    //RAM的数据写入  
    output reg [7:0] addr        //RAM的读写地址     
);  
   
    //计数器最大值（0.1s）
    parameter  cnt_max = 24'd4_999_999;//24'd499;
    reg [23:0] cnt_val;          //计数值
    reg        cnt_flag;         //计数标志位
    reg [1:0]  key_record;
    reg        chg_flag;         //允许ROM读地址变化的标注位
    reg        w_flag;           //允许ROM写入的标注位
    
    
    //4种状态：开始递增，停止递增，跳转到addr=100再递增，修改RAM的值再重新递增
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
            w_flag <= 1'b0;
            data_in <= 8'd0;
            chg_flag <= 1'b1;
        end
        else if(w_flag == 1'b1) begin       /*开始重写RAM,优先级很高*/
            if(addr == 8'd255) begin   //从头开始读RAM
                w_flag <= 1'b0; 
                addr <= 8'd0;
                chg_flag <= 1'b1; 
            end
            else begin
                data_in <= data_in + 8'd2; 
                addr <= addr + 8'd1;
            end
        end
        else if(key_flag == 1'b1)          /*判断按键是否按下，优先级较高*/
            case(key_record)
                2'b00: chg_flag <= 1'b1;    /*开始递增*/
                2'b01: chg_flag <= 1'b0;    /*停止递增*/
                2'b10: begin                /*跳转到addr=100再递增*/
                        chg_flag <= 1'b1; 
                        addr <= 8'd100;
                       end
                2'b11: begin                /*修改RAM的值再重新递增*/
                        w_flag <= 1'b1;     //开启写标志
                        addr <= 8'd0;   
                        data_in <= 8'd0;
                       end
            endcase
        else if(cnt_flag == 1'b1 && chg_flag == 1'b1)   
            addr <= addr + 8'd1;
        else
            addr <= addr;
    end
    
    assign wren = w_flag;
    assign rden = ~w_flag;
    
endmodule

