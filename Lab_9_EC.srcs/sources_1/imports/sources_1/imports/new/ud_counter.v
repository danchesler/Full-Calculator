`timescale 1ns / 1ps

module ud_counter(  input clk, rst, ce, ld, ud,
                    input [2:0] D,
                    output reg [2:0] Q );

reg [3:0] ctrl = 0;

parameter
    RESET = 4'b1xxx,
    HOLD =  4'b00xx,
    LOAD =  4'b011x,
    UP =    4'b0101,
    DOWN =  4'b0100;
    
always @ (posedge clk)
begin
ctrl = {rst, ce, ld, ud};
    casex (ctrl)
        RESET:  Q <= 0;
        HOLD:   Q <= Q;
        LOAD:   Q <= D;
        UP:     Q <= Q + 1;
        DOWN:   Q <= Q - 1;
    endcase
end
endmodule
