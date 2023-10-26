module PWM 
#(
    parameter freq = 12'd1000,      //≤ 4096Hz
    parameter duty_cycle = 7'd60    //60意味着60%, ≤ 128
 )
(
    input wire sys_clk, 
    input wire rst_n,     //异步复位 
    output reg PWM_out               
);  

    parameter end_overflow_val = 26'd 50_000_000 / freq;                   //周期结束
    parameter dwn_overflow_val = end_overflow_val * duty_cycle / 7'd100;   //高电平结束（占空比控制）
    
    reg [25:0] end_cnt_val;
    reg [25:0] dwn_cnt_val;
    reg end_flag, dwn_flag;
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            end_cnt_val <= 26'd0;
            end_flag <= 1'd0;
            end
        else begin
            if(end_cnt_val == end_overflow_val - 26'd2) 
                end_flag <= 1'd1;
            if(end_cnt_val == end_overflow_val - 26'd1) begin
                end_cnt_val <= 26'd0;
                end_flag <= 1'd0;
                end
            else 
                end_cnt_val <= end_cnt_val + 26'd1;
        end
    end

       
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            dwn_cnt_val <= 26'd0;
            dwn_flag <= 1'b0;
            end
        else begin
            if(end_flag == 1'b1) begin
                dwn_cnt_val <= 26'd0;
                dwn_flag <= 1'b0;
            end
            else if(dwn_cnt_val == dwn_overflow_val - 26'd1) 
                dwn_flag <= 1'b1;
            else begin
                dwn_cnt_val <= dwn_cnt_val + 26'd1;
            end
        end
    end
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            PWM_out <= 1'b0;
        else
            PWM_out <= ~dwn_flag;
        /*else if(dwn_flag == 1'b0)
            PWM_out <= 1'b1;
        else if(dwn_flag == 1'b1)    
            PWM_out <= 1'b0;
        else
            PWM_out <= PWM_out;*/
    end
    
endmodule


