module UART_RX_ctrl 
(
    input  wire      sys_clk, 
    input  wire      rst_n,      //异步复位 
    input  wire[7:0] rx_data,    //接收到的数据
    output wire      valid_flag, //接收数据有效信号         
    output reg[1:0]  led_switch,         
    output reg       b_en,       //呼吸灯模块使能信号  
    output reg       f_en        //流水灯模块使能信号    
);  

    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            led_switch <= 2'b00;
            b_en <= 1'b0;
            f_en <= 1'b0;
        end
        else if(valid_flag == 1'b1) 
            case(rx_data)
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



    
endmodule


