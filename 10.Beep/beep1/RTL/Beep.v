module Beep 
(
    input wire sys_clk, 
    input wire rst_n,     //异步复位 
    output wire Beep               
);  


    reg [24:0] time_500ms_cnt;
    reg time_500ms_flag;
    reg [17:0] pwm_overflow, pwm_cnt;
    reg [2:0] num;
    /*parameter DO = 18'd190_839;             //"DO"音调分频计数值（频率262）
    parameter RE = 18'd170_067;             //"RE"音调分频计数值（频率294）
    parameter MI = 18'd151_514;             //"MI"音调分频计数值（频率330）
    parameter FA = 18'd143_265;             //"FA"音调分频计数值（频率349）
    parameter SO = 18'd127_550;             //"SO"音调分频计数值（频率392）
    parameter LA = 18'd113_635;             //"LA"音调分频计数值（频率440）
    parameter XI = 18'd101_214;             //"XI"音调分频计数值（频率494）
    parameter TIME_500MS = 25'd24_999_999;  //0.5s计数值*/
    
    parameter DO = 18'd10;             //"DO"音调分频计数值（频率262）
    parameter RE = 18'd20;             //"RE"音调分频计数值（频率294）
    parameter MI = 18'd30;             //"MI"音调分频计数值（频率330）
    parameter FA = 18'd40;        //"FA"音调分频计数值（频率349）
    parameter SO = 18'd50;             //"SO"音调分频计数值（频率392）
    parameter LA = 18'd60;       //"LA"音调分频计数值（频率440）
    parameter XI = 18'd70;             //"XI"音调分频计数值（频率494）
    parameter TIME_500MS = 25'd150;  //0.5s计数值


    //0.5s计时
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            time_500ms_cnt <= 25'd0;
            time_500ms_flag <= 1'b0;
        end
        else begin
            if(time_500ms_cnt == TIME_500MS) begin
                time_500ms_cnt <= 25'd0;
                time_500ms_flag <= 1'b1;
            end
            else begin
                time_500ms_cnt <= time_500ms_cnt + 25'd1;
                time_500ms_flag <= 1'b0;
            end
        end
    end
    
    //更改应该演奏的音阶
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            num <= 3'd1;
        else if(time_500ms_flag == 1'b1)begin
            if(num == 3'd7) 
                num <= 3'd1;
            else 
                num <= num + 3'd1;
        end
        else
            num <= num;
    end
    //修改对应音阶的PWM计数阈值
    always @(*) begin
        case(num)
            3'd1:pwm_overflow = DO;
            3'd2:pwm_overflow = RE;
            3'd3:pwm_overflow = MI;
            3'd4:pwm_overflow = FA;
            3'd5:pwm_overflow = SO;
            3'd6:pwm_overflow = LA;
            3'd7:pwm_overflow = XI;
        endcase
    end
    
    //产生对应音阶的PWM
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            pwm_cnt <= 18'd0;
        else begin
            if(pwm_cnt >= pwm_overflow) 
                pwm_cnt <= 18'd0;
            else 
                pwm_cnt <= pwm_cnt + 18'd1;
        end
    end
    
    assign Beep = (pwm_cnt >= pwm_overflow * 10 / 100) ? 0 : 1;   //PWM占空比为30％，可以调节音量
    
endmodule


