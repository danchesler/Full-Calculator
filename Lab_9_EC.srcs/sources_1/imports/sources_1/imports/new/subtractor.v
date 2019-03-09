`timescale 1ns / 1ps

module subtractor(  input [3:0] a, b,
                    output reg [3:0] c );                 
always @ (*)
begin
    c = a - b;
end
endmodule
