module MUX2_1
(
    input wire in1, in2, sel,      //sel -> KEY0, in1 -> KEY1, in2 -> KEY2
    output wire out                //out -> LED0
);
    
    assign out = ~(sel ? in1 : in2); //取反是因为低电平才能点亮LED

endmodule