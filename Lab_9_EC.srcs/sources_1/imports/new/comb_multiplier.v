`timescale 1ns / 1ps

module comb_multiplier( input[3:0] Ain, Bin,
                        output[7:0] product,
                        input clk, reset, en
                        );

wire [3:0] store_and0;
wire [3:0] store_and1; 
wire [3:0] store_and2; 
wire [3:0] store_and3;  

wire Cin = 0;

wire [7:0] PP3, PP2, PP1, PP0;

wire [7:0] PP3_PP2; //PP3 + PP2
wire [7:0] PP1_PP0; //PP1 + PP0

//store d_reg outputs
wire [7:0] d_PP3_PP2, d_PP1_PP0;

//store PP3_PP2 and PP1_PP0 into D_regs

flopenr store_PP3_PP2(  .clk(clk),
                        .reset(reset),
                        .en(en),
                        .d(PP3_PP2),
                        .q(d_PP3_PP2)   );

flopenr store_PP1_PP0(  .clk(clk),
                        .reset(reset),
                        .en(en),
                        .d(PP1_PP0),
                        .q(d_PP1_PP0)   );

//add PP3 and PP2
bit8_adder add_num1(    .A(PP3),
                        .B(PP2),
                        .Cin(Cin),
                        .sum(PP3_PP2)   );
                    
//add PP1 and PP0
bit8_adder add_num2(    .A(PP1),
                        .B(PP0),
                        .Cin(Cin),
                        .sum(PP1_PP0)   );

//add (PP3 and PP2) and (PP1 and PP0)
//to get product
bit8_adder add_sum(     .A(d_PP3_PP2),
                        .B(d_PP1_PP0),
                        .Cin(Cin),
                        .sum(product)   );

//AND modules
AND_mod and_b0( .A(Ain), 
                .B(Bin[0]), 
                .and_out(store_and0)    );
AND_mod and_b1( .A(Ain), 
                .B(Bin[1]), 
                .and_out(store_and1)    );
AND_mod and_b2( .A(Ain), 
                .B(Bin[2]), 
                .and_out(store_and2)    );
AND_mod and_b3( .A(Ain), 
                .B(Bin[3]), 
                .and_out(store_and3)    );

assign PP0 = {4'b0000, store_and0};
assign PP1 = {3'b000, store_and1, 1'b0};
assign PP2 = {2'b00, store_and2, 2'b00};
assign PP3 = {1'b0, store_and3, 3'b000};


endmodule
