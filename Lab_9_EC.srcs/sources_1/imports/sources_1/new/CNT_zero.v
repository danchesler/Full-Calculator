`timescale 1ns / 1ps

module CNT_zero(    input [2:0] CNT_IN,
                    output reg out );

always @ (*)
begin
    if ( CNT_IN == 0 )
        out = 1;
    else
        out = 0;

end
endmodule
