`timescale  1ns/1ns

module CNT_TB();

    reg clk, rst_n;
    wire led;
    
    //初始值
    initial begin
        clk <= 1'b1;
        rst_n <= 1'b0;
        #50
        rst_n <= 1'b1;
        #500
        rst_n <= 1'b0;
        #550
        rst_n <= 1'b1;
    end
    
    
    //时钟翻转
    always #10 clk <= ~clk;

    CNT  #(.cnt_val(25'd10)) 
    CNT_inst(
        .clk   (clk), 
        .rst_n (rst_n),   //异步复位  
        .led   (led)
    );
    
endmodule