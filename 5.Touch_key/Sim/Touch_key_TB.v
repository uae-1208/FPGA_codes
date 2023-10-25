`timescale  1ns/1ns

module Touch_key_TB();

    reg  sys_clk, rst_n, key_in;
    wire led;
    
    //初始值
    initial begin
        sys_clk <= 1'b1;
        rst_n <= 1'b0;
        key_in <= 1'b1;
        #50
        rst_n <= 1'b1;
        #105
        key_in <= 1'b0;
        #165
        key_in <= 1'b1;
        #500
        rst_n <= 1'b0;
        #550
        rst_n <= 1'b1;
        #725
        key_in <= 1'b0;
        #855
        key_in <= 1'b1;
        end
    
    //时钟翻转
    always #10 sys_clk <= ~sys_clk;

    Touch_key  Touch_key_inst(
               .sys_clk (sys_clk), 
               .rst_n   (rst_n),     
               .key_in  (key_in), 
               .led     (led)
               );
    
endmodule