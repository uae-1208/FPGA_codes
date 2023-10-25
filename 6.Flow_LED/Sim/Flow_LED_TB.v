`timescale  1ns/1ns

module Flow_LED_TB();

    reg  sys_clk, rst_n;
    wire [3:0] led;
    
    //初始值
    initial begin
        sys_clk <= 1'b1;
        rst_n <= 1'b0;
        #50
        rst_n <= 1'b1;
        #500
        rst_n <= 1'b0;
        #550
        rst_n <= 1'b1;
        end
    
    //时钟翻转
    always #10 sys_clk <= ~sys_clk;

    Flow_LED  #(.overflow_val(25'd10))
    Flow_LED_inst(
        .sys_clk (sys_clk), 
        .rst_n   (rst_n),     
        .led     (led)
    );
    
endmodule