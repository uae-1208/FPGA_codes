`timescale  1ns/1ns

module Seg_Ctrl_TB();

    reg sys_clk, rst_n;
    reg [23:0] display_val_bcd;
    wire [5:0] sel;
    wire [7:0] seg;
    
    //初始值
    initial begin
        sys_clk         <= 1'b1;
        rst_n           <= 1'b0;
        display_val_bcd <= 24'd0;
        #50
        rst_n <= 1'b1;
        #500
        rst_n <= 1'b0;
        #550
        rst_n <= 1'b1;
        end
    
    //时钟翻转
    always #10 sys_clk <= ~sys_clk;

    //产生随机电平
    always #5000 display_val_bcd[0]  <= {$random} % 2;
    always #5000 display_val_bcd[1]  <= {$random} % 2;
    always #5000 display_val_bcd[2]  <= {$random} % 2;
    always #5000 display_val_bcd[3]  <= {$random} % 2;
    always #5000 display_val_bcd[4]  <= {$random} % 2;
    always #5000 display_val_bcd[5]  <= {$random} % 2;
    always #5000 display_val_bcd[6]  <= {$random} % 2;
    always #5000 display_val_bcd[7]  <= {$random} % 2;
    always #5000 display_val_bcd[8]  <= {$random} % 2;
    always #5000 display_val_bcd[9]  <= {$random} % 2;
    always #5000 display_val_bcd[10] <= {$random} % 2;
    always #5000 display_val_bcd[11] <= {$random} % 2;
    always #5000 display_val_bcd[12] <= {$random} % 2;
    always #5000 display_val_bcd[13] <= {$random} % 2;
    always #5000 display_val_bcd[14] <= {$random} % 2;
    always #5000 display_val_bcd[15] <= {$random} % 2;
    always #5000 display_val_bcd[16] <= {$random} % 2;
    always #5000 display_val_bcd[17] <= {$random} % 2;
    always #5000 display_val_bcd[18] <= {$random} % 2;
    always #5000 display_val_bcd[19] <= {$random} % 2;
    always #5000 display_val_bcd[20] <= {$random} % 2;
    always #5000 display_val_bcd[21] <= {$random} % 2;
    always #5000 display_val_bcd[22] <= {$random} % 2;
    always #5000 display_val_bcd[23] <= {$random} % 2;

    Seg_Ctrl    Seg_Ctrl_inst
                (
                    .sys_clk          (sys_clk), 
                    .rst_n            (rst_n),     
                    .display_val_bcd  (display_val_bcd),     
                    .sel              (sel),     
                    .seg              (seg)
                );
    
endmodule