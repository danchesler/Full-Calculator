`timescale 1ns / 1ps

module shift_register #(parameter WIDTH = 5)
    (   input CLK, RST, SL, SR, LD, LeftIn, RightIn,
        input [WIDTH-1:0] D,
        output reg [WIDTH-1:0] Q );

reg [3:0] ctrl = 0;

parameter
    RESET =     4'b1xxx,
    LOAD =      4'b01xx,
    SHIFT_L =   4'b001x,
    SHIFT_R =   4'b0001;
    
always @ (posedge CLK)
begin
ctrl = {RST, LD , SL, SR};
    casex (ctrl)
        RESET:      Q <= 0;
        LOAD:       Q <= D;
        SHIFT_L:    Q <= {Q[WIDTH-2:0], RightIn}; //or should it be {Q[WIDTH-2:0],Rin}
        SHIFT_R:    Q <= {LeftIn, Q[WIDTH-1:1]}; //or should it be {Lin, Q[WIDTH-1:1}
        default:    Q <= Q;
    endcase
end      
endmodule
