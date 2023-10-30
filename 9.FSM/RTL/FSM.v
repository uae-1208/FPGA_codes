module FSM 
(
    input wire sys_clk, 
    input wire rst_n,     //异步复位 
    input wire[1:0] in,   //投钱：[1块，5毛]
    output reg[1:0] out  //输出：[饮料，找5毛]           
);  

    reg[2:0] state, next_state;
    parameter IDLE =      3'b000;
    parameter Half =      3'b001;
    parameter One =       3'b010;
    parameter ThreeHalf = 3'b011;
    parameter Two =       3'b100;
    parameter FiveHalf =  3'b101;
    parameter Three =     3'b110;
   
   
    //组合逻辑
    always @(*) begin
        case(state)
            IDLE:   if(in == 2'b00)
                        next_state = IDLE;
                    else if(in == 2'b01)
                        next_state = Half;
                    else if(in == 2'b10)
                        next_state = One;
                    else
                        next_state = IDLE;
                        
            Half:   if(in == 2'b00)
                        next_state = Half;
                    else if(in == 2'b01)
                        next_state = One;
                    else if(in == 2'b10)
                        next_state = ThreeHalf;
                    else
                        next_state = Half;
                        
            One:   if(in == 2'b00)
                        next_state = One;
                    else if(in == 2'b01)
                        next_state = ThreeHalf;
                    else if(in == 2'b10)
                        next_state = Two;
                    else
                        next_state = One;
                        
            ThreeHalf:if(in == 2'b00)
                        next_state = ThreeHalf;
                    else if(in == 2'b01)
                        next_state = Two;
                    else if(in == 2'b10)
                        next_state = FiveHalf;
                    else
                        next_state = ThreeHalf;
                        
            Two:    if(in == 2'b00)
                        next_state = Two;
                    else if(in == 2'b01)
                        next_state = FiveHalf;
                    else if(in == 2'b10)
                        next_state = Three;
                    else
                        next_state = Two;
                        
            FiveHalf:   next_state = IDLE;
            Three:      next_state = IDLE;
        endcase
    end
    
    //时序逻辑
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            state <= IDLE;
        else 
            state <= next_state;
    end
    
    
    //输出
    always @(*) begin
        case(state)
            IDLE:      out = 2'b00;
            Half:      out = 2'b00;
            One:       out = 2'b00;
            ThreeHalf: out = 2'b00;  
            Two:       out = 2'b00;
            FiveHalf:  out = 2'b10;
            Three:     out = 2'b11;
        endcase
    end
endmodule


