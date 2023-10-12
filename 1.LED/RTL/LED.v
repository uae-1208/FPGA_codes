module LED
(
    input wire key1, key2, key3, key4,
    output wire led1, led2, led3, led4
);
    
    assign led1 = ~key1;
    assign led2 = ~key2;
    assign led3 = ~key3;
    assign led4 = ~key4;

endmodule