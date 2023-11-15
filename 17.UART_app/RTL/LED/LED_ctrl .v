module LED_ctrl 
(
    input  wire      sys_clk, 
    input  wire      rst_n,      //异步复位 
    input  wire[1:0] led_switch, //led选择开关
    input  wire      b_en,      
    input  wire      f_en,      
    output reg[3:0]  led               
);  
    
    reg[3:0]  led_reg;
    reg[3:0]  f_led_reg;
    reg[3:0]  b_led_reg;
    
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            led_reg <= 4'd0;
        else if((f_en == 1'b1) || (b_en == 1'b1)) 
            led_reg <= led;
        else
            led_reg <= led_reg;
        end
    end


    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            led <= 4'd0;
        else 
            case(led_switch)
                2'b01:   led <= b_led_reg;
                2'b10:   led <= f_led_reg;
                default: led <= led_reg;
    end
    
endmodule


