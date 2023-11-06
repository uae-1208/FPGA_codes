//降频法:
//时钟信号(晶振)要连接至全局时钟网络，这样才能保证时钟信号到达各个逻辑单元的时延基本相同
//将晶振信号进行普通的分配得到的新时钟信号无法连接至全局时钟网络，因此无法直接使用。
//时钟信号的具体作用实际上就是将其边沿作为触发沿，而产生下面的flag信号也能生成目标频率的边沿触发信号，同时还能保证到达各个逻辑单元的时延基本相同：
//23min --- https://www.bilibili.com/video/BV17z411i7er/?p=17&vd_source=d791a57f43dad7ca6a1d62950cab7001

module Div16 
(
    input wire clk, 
    input wire rst_n,   //异步复位  
    output reg flag               
);

    localparam cnt_val = 4'd15;
    reg [3:0] cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            cnt <= 4'd0;
        else begin
            if(cnt == cnt_val)
                cnt <= 4'd0;
            else
                cnt <= cnt + 4'd1;
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            flag <= 1'b0;
        else begin
            if(cnt == cnt_val)
                flag <= 1'b1;
            else
                flag <= 1'b0;          //if分支情况要罗列完整，使这条语句生成触发器，否则生成了锁存器
        end
    end
    
endmodule