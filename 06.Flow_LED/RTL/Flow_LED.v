module Flow_LED #(parameter overflow_val = 25'd7_999_999)
(
    input wire sys_clk, 
    input wire rst_n,     //异步复位 
    output reg [3:0] led               
);  
    reg [24:0] cnt_val;
    reg flag;
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            cnt_val <= 25'd0;
        else begin
            if(cnt_val == overflow_val)
                cnt_val <= 25'd0;
            else
                cnt_val <= cnt_val + 25'd1;
        end
    end

       
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            flag <= 1'b0;
        else if(cnt_val == overflow_val)
            flag <= 1'b1;
        else    
            flag <= 1'b0;
    end
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            led <= 4'b0100;
        else if(flag == 1'b1)
            led <= {led[2:0], led[3]};
        else    
            led <= led;
    end
    
endmodule