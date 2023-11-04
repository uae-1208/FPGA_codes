module RAM 
(
    input  wire      sys_clk,
    input  wire      rst_n,    //异步复位     
    input  wire      key_in,   //电容按键
    output wire[5:0] sel,      //位选，低s电平有效           
    output wire[7:0] seg       //段选，共阳极LED，低电平有效     
);  
    wire key_flag; 
    wire rden, wden;
    wire[7:0] ram_data_in;
    wire[7:0] address_8bit;
    wire[7:0] q_out;
    
    
    ram_256x8	ram_256x8_inst(
                    .address(address_8bit),
                    .clock  (sys_clk),
                    .data   (ram_data_in),
                    .rden   (rden),
                    .wren   (wren),
                    .q      (q_out)
                );
    Seg_LED     Seg_LED_inst(
                    .sys_clk        (sys_clk), 
                    .rst_n          (rst_n),                  
                    .display_val_bin({12'b0, q_out}), 
                    .sel            (sel),              
                    .seg            (seg)            
                );  
    Touch_key   Touch_key_inst( 

                    .sys_clk(sys_clk), 
                    .rst_n  (rst_n),     
                    .key_in (key_in), 
                    .flag   (key_flag)            
                );
    RAM_Ctrl    RAM_Ctrl_inst(
                    .sys_clk (sys_clk), 
                    .rst_n   (rst_n),  
                    .key_flag(key_flag),
                    .rden    (rden),
                    .wren    (wren),
                    .data_in (ram_data_in),
                    .addr    (address_8bit)   
                );   
endmodule

