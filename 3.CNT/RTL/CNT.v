module CNT #(parameter cnt_val = 25'd12_499_999)//25'd24_999_999
(
    input wire clk, 
    input wire rst_n,   //异步复位  
    output reg led               
);

    reg [24:0] cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            cnt <= 25'd0;
        else begin
            if(cnt == cnt_val)
                cnt <= 25'd0;
            else
                cnt <= cnt + 25'd1;
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            led <= 1'b1;
        else begin
            if(cnt == cnt_val)
                led <= ~led;
            else
                led <= led;          //if分支情况写全，使这条语句生成触发器，否则生成了锁存器
        end
    end
    
endmodule