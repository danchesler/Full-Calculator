`timescale 1ns / 1ps

module Divider_Top( input [3:0] X, Y,
                    input clk, go ,rst, 
                    output [3:0] R, Q,
                    output Done, Error,
                    
                    //needed for tb
                    output reg  R_lt_Y,
                                YchkOut );
    
//Instantiated DP and CU
wire rlty, Y_check, CNT_check; //flags
wire [2:0] CNT;             //count
wire    R_SL, R_SR, R_LD,   //controls for regs
        X_SL, X_LD,
        Y_LD,
        sel_Reg, sel_R, sel_Q, sel_Rin, //controls for muxes
        ce, c_ld;    //counter control  

//needed for tb
always @ (*)
begin
R_lt_Y = rlty;
YchkOut = Y_check;       
end 
    
//instantiated top module
int_divider DP( .X(X), .Y(Y),
                .clk(clk), .rst(rst), 
                .R_sl(R_SL), .R_sr(R_SR), .R_ld(R_LD),
                .X_sl(X_SL), .X_ld(X_LD),
                .Y_ld(Y_LD),
                .sel_Reg(sel_Reg), .sel_R(sel_R), .sel_Q(sel_Q), .sel_Rin(sel_Rin),
                .ce(ce), .c_ld(c_ld),
                .R(R), .Q(Q),
                .R_lt_Y(rlty), .Y_zero(Y_check), .CNT_zero(CNT_check) );
                
cu CU(  .clk(clk), .go(go), .rst(rst),
        .rlty(rlty), .CNT(CNT_check), .Y(Y_check),
        .R_sl(R_SL), .R_sr(R_SR), .R_ld(R_LD),
        .X_sl(X_SL), .X_ld(X_LD),
        .Y_ld(Y_LD), 
        .sel_Reg(sel_Reg), .sel_R(sel_R), .sel_Q(sel_Q), .sel_Rin(sel_Rin),
        .ce(ce), .c_ld(c_ld),
        .Done(Done), .Error(Error) );

endmodule
