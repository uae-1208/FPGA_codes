module UART_TX_ctrl 
(
    input  wire     sys_clk, 
    input  wire     rst_n,     //异步复位 
    input  wire     rx,        //串行数据接收端
    output wire     busy_flag,        
    output reg[1:0] led_switch,        
    output reg      b_en,      //呼吸灯模块使能信号  
    output reg      f_en,      //流水灯模块使能信号    
    output wire     tx         //串行数据输出端           
);  

    reg      valid_flag;
    reg[7:0] rx_reg;
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            led_switch <= 2'b00;
            b_en <= 1'b0;
            f_en <= 1'b0;
        end
        else if(valid_flag == 1'b1) 
            case(rx_reg)
                'B':    begin
                            led_switch <= 2'b01;
                            b_en <= 1'b1;
                            f_en <= 1'b0;
                        end
                'b':    begin
                            led_switch = 2'b01;
                            b_en <= 1'b1;
                            f_en <= 1'b0;
                        end
                'F':    begin
                            led_switch = 2'b10;
                            b_en <= 1'b0;
                            f_en <= 1'b1;
                        end
                'f':    begin
                            led_switch = 2'b10;
                            b_en <= 1'b0;
                            f_en <= 1'b1;
                        end
                default:begin
                            led_switch <= 2'b00;
                            b_en <= 1'b0;
                            f_en <= 1'b0;
                        end
            endcase
        else begin
            led_switch <= led_switch;
            b_en <= b_en;
            f_en <= f_en;
        end
    end



    TX  TX_inst(
            .sys_clk    (sys_clk       ),
            .rst_n      (rst_n         ),
            .data_in    (data_8bit_temp),
            .tx_en      (enable        ),
            .busy_flag  (busy_flag     ),
            .tx         (tx            ) 
        );                             
                                       
    RX  RX_inst(                       
            .sys_clk    (sys_clk   ),
            .rst_n      (rst_n     ),
            .rx         (rx        ),
            .valid_flag (valid_flag),
            .data_out   (rx_reg    )        
        );  
    
endmodule


