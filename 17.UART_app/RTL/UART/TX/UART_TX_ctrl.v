module UART_TX_ctrl 
(
    input  wire     sys_clk, 
    input  wire     rst_n,     //异步复位 
    input  wire     rx,        //串行数据接收端
    input  wire     key_in, 
    output wire     busy_flag,        
    output wire     tx         //串行数据输出端           
);  

    
    reg      key_falg;
    reg      enable;
    reg[7:0] tx_reg;
    reg[1:0] tx_cnt;

    
    //修改tx_cnt
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            tx_cnt <= 2'd0;
        else if(key_falg == 1'b1)
            tx_cnt <= tx_cnt + 2'd1;
        else
            tx_cnt <= tx_cnt;
    end
    
    
    //修改enable
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            enable <= 1'b0;
        else if(key_falg == 1'b1)    //使能TX_inst模块，发送tx_reg中的数据
            enable <= 1'b1;
        else
            enable <= 1'b0;
    end
    
    
    //修改tx_reg
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            tx_reg <= 8'd0;
        else 
            case(tx_cnt)
                2'b00:  tx_reg <= 'A';
                2'b01:  tx_reg <= 'B';
                2'b10:  tx_reg <= 'C';
                2'b11:  tx_reg <= 'D';
                default:tx_reg <= 8'd0;
    end
    
    
    
    TX  TX_inst(
            .sys_clk    (sys_clk  ),
            .rst_n      (rst_n    ),
            .data_in    (tx_reg   ),
            .tx_en      (enable   ),
            .busy_flag  (busy_flag),
            .tx         (tx       ) 
        );                             
                 
                 
    Touch_key   Touch_key_inst(
                    .sys_clk    (sys_clk),
                    .rst_n      (rst_n  ),
                    .key_in     (key_in ),
                    .flag       (flag   )
                ); 
    
endmodule


