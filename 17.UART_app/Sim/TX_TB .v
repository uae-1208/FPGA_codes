`timescale  1ns/1ns

module TX_TB();

    reg       sys_clk;
    reg       rst_n;
    reg       tx_en;
    reg[7:0]  data_in;
    wire      busy_flag;
    wire      tx;
    
    
    //初始值
    initial begin
        sys_clk <= 1'b1;
        rst_n   <= 1'b0;
        tx_en   <= 1'b0;
        data_in <= 8'd0;
        #20;
        rst_n   <= 1'b1;        
        
        //测试在数据发送过程中拉低tx_en，TX模块是否仍在工作
        #200;
        data_in <= 8'd85;
        #100;
        tx_en   <= 1'b1;     
        #30000;
        tx_en   <= 1'b0;     


        #3000000;
        data_in <= 8'd179;
        #100;
        tx_en   <= 1'b1;  
        #30000;
        tx_en   <= 1'b0;  

        //测试在数据发送过程中重新拉高tx_en，TX模块是否还在发送原数据
        #500000;
        data_in <= 8'd85;
        #5000;
        tx_en   <= 1'b1;  
    end
    
    
    //时钟翻转
    always #10 sys_clk = ~sys_clk;
    
    



    TX  TX_inst(
            .sys_clk    (sys_clk   ), 
            .rst_n      (rst_n     ),      
            .data_in    (data_in   ),   
            .tx_en      (tx_en     ),  
            .busy_flag  (busy_flag ),  
            .tx         (tx        )  
        );  
    
endmodule