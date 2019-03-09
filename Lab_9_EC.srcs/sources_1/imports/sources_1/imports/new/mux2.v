`timescale 1ns / 1ps
//2-to-1 mux
module mux2 #(parameter WIDTH = 5)
(   input [WIDTH-1:0] a, b,
    input sel,
    output reg [WIDTH-1:0] out );


always @(*)
begin
    case (sel)
        1'b1: out = a;
        default: out = b;
    endcase
end
endmodule
