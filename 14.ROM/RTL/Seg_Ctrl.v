module Seg_Ctrl 
(
    input  wire       sys_clk, 
    input  wire       rst_n,            //异步复位 
    input  wire[23:0] display_val_bcd,  
    output reg [5:0]  sel,              //位选，低电平有效           
    output reg [7:0]  seg               //段选，共阳极LED，低电平有效      
);  
   
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
    //计数器最大值（1ms）
    parameter   cnt_max = 16'd49_999;  //闪烁频率为1kHz
    reg [15:0] cnt_val;                //计数值
    reg        cnt_flag;               //计数标志位
    reg [3:0]  display_val;            //显示值
    reg [5:0]  non_zero_flag;          //用以判断高位是否为0
    
    //计数
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_val <= 16'd0;
            cnt_flag <= 1'd0;
        end
        else if(cnt_val == cnt_max) begin
            cnt_val <= 16'd0;
            cnt_flag <= 1'd1;
        end
        else begin
            cnt_val <= cnt_val + 16'd1;
            cnt_flag <= 1'd0;
        end
    end
    
    
    //计数标志，位选信号移位
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            sel <= 6'b011_111;
        else if(cnt_flag == 1'b1) begin
            sel <= {sel[4:0], sel[5]};
        end
        else
            sel <= sel;
    end
    
    
    //修正non_zero_flag
    always @(*) begin
        if(display_val_bcd[23:20] != 4'd0)        //第6位数字不为0
            non_zero_flag = 6'b111_111;
        else if(display_val_bcd[19:16] != 4'd0)   //第5位数字不为0，更高位为0
            non_zero_flag = 6'b011_111;
        else if(display_val_bcd[15:12] != 4'd0)   //第4位数字不为0，更高位为0
            non_zero_flag = 6'b001_111;                          
        else if(display_val_bcd[11:8] != 4'd0)    //第3位数字不为0，更高位为0
            non_zero_flag = 6'b000_111;                          
        else if(display_val_bcd[7:4] != 4'd0)     //第2位数字不为0，更高位为0
            non_zero_flag = 6'b000_011;                         
        else if(display_val_bcd[3:0] != 4'd0)     //第1位数字不为0，更高位为0
            non_zero_flag = 6'b000_001;
        else                                      //所有数字均为0
            non_zero_flag = 6'b000_000;
    end
    
    
    //根据位选信号确定要显示的数字
    //在遇到第一个非0高位之前，更高位不显示（即令display_val大于9，seg = IDLE）
    always @(*) begin
        //举例：若第5、6位为0，第4位不为0，则non_zero_flag = 001_111,那么sel = 011_111/101_111时，non_zero_flag & (~sel)均为0
        if(non_zero_flag & (~sel))   
            case(sel)   
                6'b111_110: display_val = display_val_bcd[3:0];
                6'b111_101: display_val = display_val_bcd[7:4];
                6'b111_011: display_val = display_val_bcd[11:8];
                6'b110_111: display_val = display_val_bcd[15:12];
                6'b101_111: display_val = display_val_bcd[19:16];
                6'b011_111: display_val = display_val_bcd[23:20];    
                default:    display_val = display_val_bcd[3:0];
            endcase        
        else
            display_val = 4'hf;
    end
    
    
    //根据要显示的数字确定段选信号
    always @(posedge sys_clk, negedge rst_n) begin
        if(rst_n == 1'b0) 
            seg <= IDLE;
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
                default:seg <= IDLE; 
            endcase
    end
    
endmodule

