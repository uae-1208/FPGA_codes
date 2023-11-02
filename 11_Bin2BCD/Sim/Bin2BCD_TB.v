`timescale  1ns/1ns

module Bin2BCD_TB();

    reg [19:0] bin_in;
    wire [23:0] bcd_out;
    
    //初始值
    initial bin_in <= 20'b1110_1010;
        

    //产生随机电平
    always #500 bin_in[0]  <= {$random} % 2;
    always #500 bin_in[1]  <= {$random} % 2;
    always #500 bin_in[2]  <= {$random} % 2;
    always #500 bin_in[3]  <= {$random} % 2;
    always #500 bin_in[4]  <= {$random} % 2;
    always #500 bin_in[5]  <= {$random} % 2;
    always #500 bin_in[6]  <= {$random} % 2;
    always #500 bin_in[7]  <= {$random} % 2;
    always #500 bin_in[8]  <= {$random} % 2;
    always #500 bin_in[9]  <= {$random} % 2;
    always #500 bin_in[10] <= {$random} % 2;
    always #500 bin_in[11] <= {$random} % 2;
    always #500 bin_in[12] <= {$random} % 2;
    always #500 bin_in[13] <= {$random} % 2;
    always #500 bin_in[14] <= {$random} % 2;
    always #500 bin_in[15] <= {$random} % 2;
    always #500 bin_in[16] <= {$random} % 2;
    always #500 bin_in[17] <= {$random} % 2;
    always #500 bin_in[18] <= {$random} % 2;
    always #500 bin_in[19] <= {$random} % 2;



    Bin2BCD  Bin2BCD_inst
             (
                 .bin_in  (bin_in),     
                 .bcd_out (bcd_out)
             );
    
endmodule