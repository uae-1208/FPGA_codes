module Div15 
(
    input wire clk, 
    input wire rst_n,   //异步复位  
    output wire clk_div15               
);

    localparam cnt_val = 4'd14;
    reg [3:0] cnt;
    reg clk_up,clk_down;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            cnt <= 4'd0;
        else begin
            if(cnt == cnt_val)
                cnt <= 4'd0;
            else
                cnt <= cnt + 4'd1;
        end
    end


    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) 
            clk_up <= 1'd0;
        else begin
            if(cnt == cnt_val/2)
                clk_up <= 1'd1;
            else if(cnt == cnt_val)
                clk_up <= 1'd0;
            else    
                clk_up <= clk_up;
        end
    end
    
    
    always @(negedge clk, negedge rst_n) begin
        if(!rst_n) 
            clk_down <= 1'd0;
        else begin
            if(cnt == cnt_val/2)
                clk_down <= 1'd1;
            else if(cnt == cnt_val)
                clk_down <= 1'd0;
            else    
                clk_down <= clk_down;
        end
    end
    
    assign clk_div15 = clk_up | clk_down;
    
endmodule