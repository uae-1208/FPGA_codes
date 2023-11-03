module Seg_LED 
(
    input wire sys_clk, 
    input wire rst_n,       //异步复位 
    output wire [5:0] sel,  //位选，低s电平有效           
    output wire [7:0] seg   //段选，共阳极LED，低电平有效           
);  

    parameter   cnt_max = 25'd499_999;   //计数器最大值（0.01s）
    
    reg [24:0] cnt_val;          //计数值
    reg        cnt_flag;         //计数标志位
    reg [19:0] display_val_bin;  //二进制显示值
    wire [23:0] display_val_bcd;  //BCD码显示值
    
    //计数
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_val <= 25'd0;
            cnt_flag <= 1'd0;
        end
        else if(cnt_val == cnt_max) begin
            cnt_val <= 25'd0;
            cnt_flag <= 1'd1;
        end
        else begin
            cnt_val <= cnt_val + 25'd1;
            cnt_flag <= 1'd0;
        end
    end
    
    
    //计数标志,计数值递增
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            display_val_bin <= 20'd0;
        else if(cnt_flag == 1'b1) begin
            if(display_val_bin == 20'd999_999)
                display_val_bin <= 20'd0;
            else
                display_val_bin <= display_val_bin + 20'd1;
        end
        else
            display_val_bin <= display_val_bin;
    end
    
    
    
    Bin2BCD  Bin2BCD_inst
             (
                 .bin_in  (display_val_bin),     
                 .bcd_out (display_val_bcd)
             );
             
    Seg_Ctrl    Seg_Ctrl_inst
                (
                    .sys_clk          (sys_clk), 
                    .rst_n            (rst_n),     
                    .display_val_bcd  (display_val_bcd),     
                    .sel              (sel),     
                    .seg              (seg)
                );
             
endmodule


