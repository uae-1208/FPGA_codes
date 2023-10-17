`timescale  1ns/1ns

module Div15_TB();

    reg clk, rst_n;
    wire clk_div15;
    
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

    Div15 Div15_inst(
          .clk      (clk), 
          .rst_n    (rst_n),   //异步复位  
          .clk_div15(clk_div15)
    );
    
endmodule