module Seg_LED 
(
    input wire sys_clk, 
    input wire rst_n,       //异步复位 
    output wire [5:0] sel,  //位选，低s电平有效           
    output reg [7:0] seg    //段选，共阳极LED，低电平有效           
);  

    parameter   cnt_max = 25'd4_999_999;   //计数器最大值（0.1s）
    //十六进制数显示编码
    parameter   SEG_0 = 8'b1100_0000,   SEG_1 = 8'b1111_1001,
                SEG_2 = 8'b1010_0100,   SEG_3 = 8'b1011_0000,
                SEG_4 = 8'b1001_1001,   SEG_5 = 8'b1001_0010,
                SEG_6 = 8'b1000_0010,   SEG_7 = 8'b1111_1000,
                SEG_8 = 8'b1000_0000,   SEG_9 = 8'b1001_0000,
                SEG_A = 8'b1000_1000,   SEG_B = 8'b1000_0011,
                SEG_C = 8'b1100_0110,   SEG_D = 8'b1010_0001,
                SEG_E = 8'b1000_0110,   SEG_F = 8'b1000_1110;
    //不显示状态
    parameter   IDLE  = 8'b1111_1111;
    
    reg [24:0] cnt_val;     //计数值
    reg  cnt_flag;          //计数标志位
    reg [3:0] display_val;  //显示值
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_val <= 25'd0;
            cnt_flag <= 1'd0;
        end
        else if(cnt_val == cnt_max) begin
            cnt_val <= 25'd0;
            cnt_flag <= 1'd1;
        end
        else begin
            cnt_val <= cnt_val + 25'd1;
            cnt_flag <= 1'd0;
        end
    end
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            display_val <= 4'd0;
        else if(cnt_flag == 1'b1) 
            display_val <= display_val + 4'd1;
        else
            display_val <= display_val;
    end
    
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            seg <= SEG_0;
        else
            case(display_val) 
                4'h0:   seg <= SEG_0;
                4'h1:   seg <= SEG_1;
                4'h2:   seg <= SEG_2;
                4'h3:   seg <= SEG_3;
                4'h4:   seg <= SEG_4;
                4'h5:   seg <= SEG_5;
                4'h6:   seg <= SEG_6;
                4'h7:   seg <= SEG_7;
                4'h8:   seg <= SEG_8;
                4'h9:   seg <= SEG_9;
                4'ha:   seg <= SEG_A;
                4'hb:   seg <= SEG_B;
                4'hc:   seg <= SEG_C;
                4'hd:   seg <= SEG_D;
                4'he:   seg <= SEG_E;
                4'hf:   seg <= SEG_F;
                default:seg <= IDLE;
            endcase
    end
    
    assign sel = 6'b000000;
endmodule


