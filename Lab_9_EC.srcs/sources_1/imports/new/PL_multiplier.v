`timescale 1ns / 1ps


module PL_multiplier(   input[3:0] A, B, 
                        input clock, rst, en,
                        output[7:0] P
    );
    
wire [3:0] Awire, Bwire;
wire [7:0] Pwire;

flopenr #(4) holdA(     .clk(clock),
                        .reset(rst),
                        .en(en),
                        .d(A),
                        .q(Awire)   );

flopenr #(4) holdB(     .clk(clock),
                        .reset(rst),
                        .en(en),
                        .d(B),
                        .q(Bwire)   );
                        
flopenr holdP(      .clk(clock),
                    .reset(rst),
                    .en(en),
                    .d(Pwire),
                    .q(P)   );
                        
comb_multiplier multi_A_B(  .Ain(Awire),
                            .Bin(Bwire),
                            .clk(clock),
                            .reset(rst),
                            .en(en),
                            .product(Pwire)  );
    
endmodule
