module Breathing_LED 
(
    input  wire     sys_clk, 
    input  wire     rst_n,    //异步复位 
    input  wire     en,       //模块使能信号
    output reg[3:0] led               
);  

    parameter overflow_val = 16'd49_999;                         //PWM的频率为1000Hz
    parameter increment = (overflow_val+16'd1) * 1 / 1000;       //增量为0.1％
    //parameter temp = (overflow_val+16'd1) * 60 / 100 - 1;      //占空比为60％

    reg [15:0] cnt;
    reg [15:0] temp;
    reg flag, dir;
    
    
    always @(posedge sys_clk, negedge rst_n) begin       //占空比的变化频率为1000Hz,每次变化0.1％
        if(rst_n == 1'b0) begin
            temp <= 16'd0;
            dir <= 1'd1;
        end
        else if(flag == 1'b1) begin
            if(dir == 1'b1)
                temp <= temp + increment;
            else
                temp <= temp - increment;
                
            if(temp >= overflow_val - 2*increment)      //2*increment只是一个阈值，比较随意
                dir <= 1'd0;
            else if(temp <= 2*increment)
                dir <= 1'd1;
            else
                dir <= dir;
        end
    end
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt <= 16'd0;
            led <= 4'b0000;
            flag <= 1'd0;
        end
        else if(en == 1'b0)
            led <= led;
        else begin
            if(cnt == temp) begin
                led <= 4'b0000;
                cnt <= cnt + 16'd1;
                flag <= flag;
            end
            else if(cnt == overflow_val) begin
                cnt <= 16'd0;
                led <= 4'b1111;
                flag <= 1'd1;             //修改占空比标志置位
            end
            else begin
                cnt <= cnt + 16'd1;
                led <= led;
                flag <= 1'd0;
            end
        end
    end
    
    
endmodule


