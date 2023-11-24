`timescale  1ns/1ns

module FIFO_TB1();

    reg       sys_clk;
    reg       rst_n;
    reg       rx;
    wire      busy_flag;
    wire      tx;
    
     
    //时钟翻转
    always #10 sys_clk = ~sys_clk;
    
    
    initial begin
        sys_clk   <= 1'b1;
        rst_n     <= 1'b0;
        rx        <= 1'b1;
        #20;
        rst_n <= 1'b1;
    end


    //调用任务rx_byte
    initial begin
        #200
        rx_byte();
    end



    task  rx_byte();  
        integer j;
        for(j=0; j<8; j=j+1)    
            rx_bit(j*10+3);
    endtask



    task rx_bit(input[7:0]  data);
        integer i;
        for(i=0; i<10; i=i+1)   begin
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
            endcase
            #(435*20);
        end
    endtask



    FIFO_sum    FIFO_sum_inst(
                    .sys_clk    (sys_clk   ), 
                    .rst_n      (rst_n     ),      
                    .rx         (rx        ),  
                    .busy_flag  (busy_flag ),  
                    .tx         (tx        )  
                );  
    
endmodule