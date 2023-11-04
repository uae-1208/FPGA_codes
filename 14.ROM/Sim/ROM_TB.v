`timescale  1ns/1ns

module ROM_TB();

    reg sys_clk, rst_n, key_in;
    wire [5:0] sel;
    wire [7:0] seg;
    
    //初始值
    initial begin
        sys_clk <= 1'b1;
        rst_n <= 1'b0;
        key_in <= 1'b1;
        
        #50
        rst_n <= 1'b1;
        #500
        rst_n <= 1'b0;
        #550
        rst_n <= 1'b1;
        
        #10005
        key_in <= 1'b0;
        #10065
        key_in <= 1'b1;
        #30725
        key_in <= 1'b0;
        #30855
        key_in <= 1'b1;
        #70725
        key_in <= 1'b0;
        #70855
        key_in <= 1'b1;
        #130725
        key_in <= 1'b0;
        #130855
        key_in <= 1'b1;
    end
    
    
    
    //时钟翻转
    always #10 sys_clk = ~sys_clk;
    


    ROM ROM_inst(
            .sys_clk (sys_clk), 
            .rst_n   (rst_n  ),      
            .key_in  (key_in ),   
            .sel     (sel    ),  
            .seg     (seg    )  
        );  
    
endmodule