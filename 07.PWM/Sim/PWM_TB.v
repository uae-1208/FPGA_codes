`timescale  1ns/1ns

module PWM_TB();

    reg  sys_clk, rst_n;
    wire PWM_out;
    
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

    PWM  #(.freq(26'd500_000), .duty_cycle(7'd60))
          PWM_inst(
              .sys_clk (sys_clk), 
              .rst_n   (rst_n),     
              .PWM_out (PWM_out)
          );
    
endmodule