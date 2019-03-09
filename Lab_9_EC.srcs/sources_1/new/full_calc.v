`timescale 1ns / 1ps


module full_calc(   input   clk, rst, go_calc, go_div, enM,
                            enX, enY, enH, enL,    
                    input [3:0] X, Y, //data inputs X, Y
                    input [1:0] op, //for small calc, use first two bits of F
                    input [1:0] selH, selL,
                    output Done_calc, Done_div,
                    output error, //for divide by zero
                    output [3:0] outH, outL
                    

    );
wire [3:0] Xout, Yout; //X and Y register outputs
wire [3:0] calc_out; //goes to muxL    
wire [7:0] P; //P[7:4] goes to muxH, P[3:0] goes to muxL
wire [3:0] R, Q; //R goes to muxH, Q goes to muxL
wire [3:0] muxHout, muxLout; //output of muxH, muxL    
small_calc calc(    .go(go_calc), .clk(clk),
                    .op(op),
                    .in1(Xout), .in2(Yout),
                    .done(Done_calc),
                    .out(calc_out) ); 

PL_multiplier multiplier(   .A(Xout), .B(Yout),
                            .clock(clk), .rst(rst), .en(enM),
                            .P(P) ); 

Divider_Top divider(    .X(Xout), .Y(Yout),
                        .clk(clk), .go(go_div), .rst(rst),
                        .R(R), .Q(Q),
                        .Done(Done_div) ,.Error(error) ); 

muxL muxH( .a(P[7:4]), .b(R), .c(X), .d(Y), //covers PH, Remainder, and Pass thru X and Y
                .sel(selH),
                .out(muxHout)); 
muxL muxL(  .a(4'b0), .b(calc_out), .c(P[3:0]), .d(Q), //covers Zero, calc_out, PL, and Quotient
            .sel(selL),
            .out(muxLout) ); 
            
flopenr #(4) holdX( .clk(clk), .reset(rst) ,.en(enX),
                    .d(X), .q(Xout) ); 
flopenr #(4) holdY( .clk(clk), .reset(rst) ,.en(enY),
                    .d(Y), .q(Yout) ); 
flopenr #(4) holdH( .clk(clk), .reset(rst), .en(enH),
                    .d(muxHout), .q(outH) );
flopenr #(4) holdL( .clk(clk), .reset(rst), .en(enL),
                    .d(muxLout), .q(outL) );

endmodule
