module Seg_LED 
(
    input  wire        sys_clk, 
    input  wire        rst_n,           //异步复位 
    input  wire [19:0] display_val_bin, //异步复位 
    output wire [5:0]  sel,             //位选，低s电平有效           
    output wire [7:0]  seg              //段选，共阳极LED，低电平有效           
);  

    wire [23:0] display_val_bcd;  //BCD码显示值
        
        
    Bin2BCD  Bin2BCD_inst(
                .bin_in  (display_val_bin),     
                .bcd_out (display_val_bcd)
            );
             
    Seg_Ctrl    Seg_Ctrl_inst(
                    .sys_clk          (sys_clk), 
                    .rst_n            (rst_n),     
                    .display_val_bcd  (display_val_bcd),     
                    .sel              (sel),     
                    .seg              (seg)
                );
             
endmodule


