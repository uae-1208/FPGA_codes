module Touch_key 
(
    input  wire sys_clk, 
    input  wire rst_n,     //异步复位 
    input  wire key_in, 
    output reg  flag               
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
    
endmodule