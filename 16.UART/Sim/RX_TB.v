`timescale  1ns/1ns

module RX_TB();

    reg       sys_clk, rst_n, rx;
    wire      valid_flag;
    wire[7:0] data_out;
    
    
    //初始值
    initial begin
        sys_clk <= 1'b1;
        rst_n   <= 1'b0;
        rx      <= 1'b1;
        #20;
        rst_n    <= 1'b1;        
    end
    
    
    //时钟翻转
    always #10 sys_clk = ~sys_clk;
    
    
    //模拟发送8次数据，分别为0~7
    initial begin
        #273
        rx_bit(8'd0);  //任务的调用，任务名+括号中要传递进任务的参数
        rx_bit(8'd7);
        rx_bit(8'd15);
        rx_bit(8'd88);
        rx_bit(8'd4);
        rx_bit(8'd62);
        rx_bit(8'd78);
        rx_bit(8'd189);
    end



    task rx_bit(input[7:0] data);
        integer i;   
        
        for(i=0; i<11; i=i+1) begin
            case(i)
                0: rx <= 1'b0;
                1: rx <= data[0];
                2: rx <= data[1];
                3: rx <= data[2];
                4: rx <= data[3];
                5: rx <= data[4];
                6: rx <= data[5];
                7: rx <= data[6];
                8: rx <= data[7];
                9: rx <= 1'b1;
                10: #(5208*59); //延时
            endcase
            #(5208*20); //每发送1位数据延时5208个时钟周期
        end
    endtask         


    RX  RX_inst(
            .sys_clk    (sys_clk   ), 
            .rst_n      (rst_n     ),      
            .rx         (rx        ),   
            .valid_flag (valid_flag),  
            .data_out   (data_out  )  
        );  
    
endmodule