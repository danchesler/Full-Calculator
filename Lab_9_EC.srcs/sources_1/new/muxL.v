`timescale 1ns / 1ps
//2-to-1 mux
module muxL(   input [3:0] a, b, c, d,
               input [1:0] sel,
               output reg [3:0] out );


always @(*)
begin
    case (sel)
        2'b10: out = b;
        2'b01: out = c;
        2'b00: out = d;
        default: out = a;
    endcase
end
endmodule
