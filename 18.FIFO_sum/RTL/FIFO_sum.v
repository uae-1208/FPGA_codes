module FIFO_sum 
(
    input  wire sys_clk, 
    input  wire rst_n,     //异步复位 
    input  wire rx,        //串行数据接收端
    output wire busy_flag,        
    output wire tx         //串行数据输出端           
);  

    wire[7:0] rx_data_8bit;
    wire[7:0] tx_data_8bit;
    wire      rx_valid;
    wire      tx_enable;
    
    UART_TX     UART_TX_inst(
                    .sys_clk    (sys_clk        ),
                    .rst_n      (rst_n          ),
                    .data_in    (tx_data_8bit   ),
                    .tx_en      (tx_enable      ),
                    .busy_flag  (busy_flag      ),
                    .tx         (tx             ) 
                );                              
                                        
    UART_RX     UART_RX_inst(                        
                    .sys_clk    (sys_clk        ),
                    .rst_n      (rst_n          ),
                    .rx         (rx             ),
                    .valid_flag (rx_valid       ),
                    .data_out   (rx_data_8bit   )        
                );  
            
    FIFO_ctrl   FIFO_ctrl_inst(                        
                  .sys_clk    (sys_clk        ),
                  .rst_n      (rst_n          ),
                  .rx_data    (rx_data_8bit   ),
                  .valid_flag (rx_valid       ),
                  .tx_data    (tx_data_8bit   ),
                  .tx_en      (tx_enable      )
                );         
endmodule


