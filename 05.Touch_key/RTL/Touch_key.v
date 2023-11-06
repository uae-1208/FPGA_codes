module Touch_key 
(
    input wire sys_clk, 
    input wire rst_n,     //异步复位 
    input wire key_in, 
    output reg led               
);
    reg  key1, key2;
    wire flag;
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            key1 <= 1'b0;
            key2 <= 1'b0;
        end
        else begin
            key1 <= key_in;
            key2 <= key1;
        end
    end

    assign flag = rst_n ? ((!key1) & (key2)) : 0;

    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            led <= 1'b0;   //熄灭
        else if(flag == 1'b1) 
            led <= ~led;
        else
            led <= led;
    end
    
    
    //这种方法似乎也可以，只是好像设计到什么亚稳态问题(目前没接触过，日后复习一下)
    /* always @(negedge key_in, negedge rst_n) begin
        if(rst_n == 1'b0) 
            led <= 1'b0;   //熄灭
        else 
            led <= ~led;
    end */
    
endmodule