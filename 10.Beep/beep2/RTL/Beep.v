module Beep 
(
    input wire sys_clk, 
    input wire rst_n,        //异步复位 
    input wire [3:0] key,    //按键输入，输入0则按下
    output wire beep,        //beep输出，输出1则响
    output wire [3:0] led    //LED输出，输出1则亮
);  


    reg [17:0] pwm_overflow, pwm_cnt;
    parameter DO = 18'd190_839;             //"DO"音调分频计数值（频率262）
    parameter RE = 18'd170_067;             //"RE"音调分频计数值（频率294）
    parameter MI = 18'd151_514;             //"MI"音调分频计数值（频率330）
    parameter FA = 18'd143_265;             //"FA"音调分频计数值（频率349）
    parameter SO = 18'd127_550;             //"SO"音调分频计数值（频率392）
    parameter LA = 18'd113_635;             //"LA"音调分频计数值（频率440）
    parameter XI = 18'd101_214;             //"XI"音调分频计数值（频率494）
    
    /*parameter DO = 18'd10;             //"DO"音调分频计数值（频率262）
    parameter RE = 18'd20;             //"RE"音调分频计数值（频率294）
    parameter MI = 18'd30;             //"MI"音调分频计数值（频率330）
    parameter FA = 18'd40;             //"FA"音调分频计数值（频率349）
    parameter SO = 18'd50;             //"SO"音调分频计数值（频率392）
    parameter LA = 18'd60;             //"LA"音调分频计数值（频率440）
    parameter XI = 18'd70;             //"XI"音调分频计数值（频率494）*/
    

    
    //按键修改音阶
    always @(*) begin
        case(key)
            4'b1111:pwm_overflow = 18'd0;     //不按下
            4'b0111:pwm_overflow = DO;        //key0
            4'b1011:pwm_overflow = RE;        //key1
            4'b1101:pwm_overflow = MI;        //key2
            4'b1110:pwm_overflow = FA;        //key3
            4'b0011:pwm_overflow = SO;        //key0、1
            4'b0101:pwm_overflow = LA;        //key0、2
            4'b0110:pwm_overflow = XI;        //key0、3
            default:pwm_overflow = 18'd0;
        endcase
    end
    
    //产生对应音阶的PWM
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0)
            pwm_cnt <= pwm_overflow;
        else begin
            if(pwm_cnt >= pwm_overflow) 
                pwm_cnt <= 18'd0;
            else 
                pwm_cnt <= pwm_cnt + 18'd1;
        end
    end
    
    assign beep = (pwm_cnt >= pwm_overflow * 10 / 100) ? 0 : 1;   //PWM占空比为10％，可以调节音量
    assign led = ~key;
endmodule


