`timescale 1ns / 1ps
//changed to 4-bit
module small_calc( input go, clk,
                input [1:0] op,
                input [3:0] in1, in2,
                output done,
                output [3:0] cs, //dont need cs output
                output [3:0] out  );

wire [1:0] s1, wa, raa, rab, c;
wire we, rea, reb, s2;

fsm fsm_mod(    .go(go), .clk(clk),
                .op(op), 
                .WE(we), .REA(rea), .REB(reb), .S2(s2),
                .S1(s1), .WA(wa), .RAA(raa), .RAB(rab), .C(c),
                .CS(cs),
                .Done(done) );

DP DP_mod(      .in1(in1), .in2(in2),         
                .s1(s1), .wa(wa), .raa(raa), .rab(rab), .c(c),
                .we(we), .rea(rea), .reb(reb), .s2(s2), .clk(clk),
                .out(out) );

endmodule
