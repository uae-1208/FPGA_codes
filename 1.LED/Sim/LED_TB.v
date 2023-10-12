`timescale  1ns/1ns


module LED_TB();

    reg key1, key2, key3, key4;
    wire led1, led2, led3, led4;
    
    //初始值为低电平
    initial key1 <= 1'b0;
    initial key2 <= 1'b0;
    initial key3 <= 1'b0;
    initial key4 <= 1'b0;
    
    //产生随机电平
    always #10 key1 <= {$random} % 2;
    always #10 key2 <= {$random} % 2;
    always #10 key3 <= {$random} % 2;
    always #10 key4 <= {$random} % 2;

    LED LED_inst
        (
        .key1 (key1),
        .key2 (key2),
        .key3 (key3),
        .key4 (key4),
        
        .led1 (led1),
        .led2 (led2),
        .led3 (led3),
        .led4 (led4)
        );

endmodule