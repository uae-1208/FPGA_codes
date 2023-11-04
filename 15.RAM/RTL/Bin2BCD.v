module Bin2BCD 
(
    input wire[19:0] bin_in,   //20位二进制输入，20'd0 ~ 20'd999_999;
    output wire[23:0] bcd_out  //24位BCD码输出，4位BCD表示1位十进制      
);  
   
    reg[19:0] temp;
    reg[3:0] ones;     //个位
    reg[3:0] tens;     //十位
    reg[3:0] hans;     //百位
    reg[3:0] thos;     //千位
    reg[3:0] t_thos;   //万位
    reg[3:0] h_thos;   //十万位
    
    integer i;
    
    
    //踩了2个坑：
    //1.移位部分，高位要先移位，否则高位要接收的是经过移位而改变了的低位
    //2.按照算法的原理，应该先修正再移位
    always @(*) begin
        temp = bin_in;
        ones = 4'd0;    tens = 4'd0;      hans = 4'd0;  
        thos = 4'd0;    t_thos = 4'd0;    h_thos = 4'd0;  
        
        for(i = 0; i < 20; i = i + 1) begin
            //修正
            if(ones > 4'd4)     ones   =  ones   +  4'd3;
            if(tens > 4'd4)     tens   =  tens   +  4'd3;
            if(hans > 4'd4)     hans   =  hans   +  4'd3;
            if(thos > 4'd4)     thos   =  thos   +  4'd3;
            if(t_thos > 4'd4)   t_thos =  t_thos +  4'd3;
            if(h_thos > 4'd4)   h_thos =  h_thos +  4'd3;

            //移位
            h_thos =  {h_thos[2:0] ,  t_thos[3]};
            t_thos =  {t_thos[2:0] ,  thos[3]};
            thos   =  {thos[2:0]   ,  hans[3]};
            hans   =  {hans[2:0]   ,  tens[3]};
            tens   =  {tens[2:0]   ,  ones[3]};
            ones   =  {ones[2:0]   ,  temp[19]};
            temp   =  {temp[18:0]  ,  1'b0};
        end
    end

    
    assign bcd_out = {h_thos, t_thos, thos, hans, tens, ones};
 
endmodule

//在Modelsim中调试所观察的中间变量
   /* reg[19:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12,temp13,temp14,temp15,temp16,temp17,temp18,temp19,temp20;
    reg[23:0] t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20;
    case(i)
                0:begin temp1 = temp; t1 = {h_thos, t_thos, thos, hans, tens, ones}; end
                1:begin temp2 = temp; t2  = {h_thos, t_thos, thos, hans, tens, ones}; end
                2:begin temp3 = temp; t3  = {h_thos, t_thos, thos, hans, tens, ones}; end
                3:begin temp4 = temp; t4  = {h_thos, t_thos, thos, hans, tens, ones}; end
                4:begin temp5 = temp; t5  = {h_thos, t_thos, thos, hans, tens, ones}; end
                5:begin temp6 = temp; t6  = {h_thos, t_thos, thos, hans, tens, ones}; end
                6:begin temp7 = temp; t7  = {h_thos, t_thos, thos, hans, tens, ones}; end
                7:begin temp8 = temp; t8  = {h_thos, t_thos, thos, hans, tens, ones}; end
                8:begin temp9 = temp; t9  = {h_thos, t_thos, thos, hans, tens, ones}; end
                9:begin temp10 = temp; t10  = {h_thos, t_thos, thos, hans, tens, ones}; end
                10:begin temp11 = temp; t11  = {h_thos, t_thos, thos, hans, tens, ones}; end
                11:begin temp12 = temp; t12  = {h_thos, t_thos, thos, hans, tens, ones}; end
                12:begin temp13 = temp; t13  = {h_thos, t_thos, thos, hans, tens, ones}; end
                13:begin temp14 = temp; t14  = {h_thos, t_thos, thos, hans, tens, ones}; end
                14:begin temp15 = temp; t15  = {h_thos, t_thos, thos, hans, tens, ones}; end
                15:begin temp16 = temp; t16  = {h_thos, t_thos, thos, hans, tens, ones}; end
                16:begin temp17 = temp; t17  = {h_thos, t_thos, thos, hans, tens, ones}; end
                17:begin temp18 = temp; t18  = {h_thos, t_thos, thos, hans, tens, ones}; end
                18:begin temp19 = temp; t19  = {h_thos, t_thos, thos, hans, tens, ones}; end
                19:begin temp20 = temp; t20  = {h_thos, t_thos, thos, hans, tens, ones}; end
            endcase*/