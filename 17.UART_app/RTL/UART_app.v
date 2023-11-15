module UART_app 
(
    input  wire sys_clk, 
    input  wire rst_n,     //异步复位 
    input  wire rx,        //串行数据接收端
    output wire busy_flag,        
    output wire tx         //串行数据输出端           
);  

    wire[7:0] data_8bit_temp;
    wire      enable;
    
    TX  TX_inst(
            .sys_clk    (sys_clk        ),
            .rst_n      (rst_n          ),
            .data_in    (data_8bit_temp ),
            .tx_en      (enable         ),
            .busy_flag  (busy_flag      ),
            .tx         (tx             ) 
        );                              
                                        
    RX  RX_inst(                        
            .sys_clk    (sys_clk        ),
            .rst_n      (rst_n          ),
            .rx         (rx             ),
            .valid_flag (enable         ),
            .data_out   (data_8bit_temp )        
        );  
    
endmodule


