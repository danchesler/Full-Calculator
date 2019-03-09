`timescale 1ns / 1ps

module HA_0 (   input a_0, b_0, 
                output reg sum_0, c_out_0);
always @ (*)
begin
    sum_0 = a_0 ^ b_0; 
    c_out_0 = a_0 & b_0;
end
endmodule