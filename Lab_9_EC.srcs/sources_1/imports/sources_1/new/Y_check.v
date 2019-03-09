`timescale 1ns / 1ps

module Y_check( input [3:0] Y,
                output reg out );

always @ (*)
begin
    if (Y == 4'b0)
        out = 1;
    else
        out = 0;
end
endmodule
