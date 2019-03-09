`timescale 1ns / 1ps

module Adder_mod(   input[3:0] Ain, Bin, 
                    input Cin, 
                    output [3:0] sum, 
                    output Cout 

                );
wire [3:0]  P;    //for sums of HA_n
                    //goes into CLA and XOR functions
wire [3:0]  G;    //for carry-out of HA_n
                    //goes into CLA_gen
wire [3:0]  cla_wire;

HA_0 add_bit_0 (.a_0(Ain[0]), 
                .b_0(Bin[0]), 
                .sum_0(P[0]),
                .c_out_0(G[0])
                );
        
HA_0 add_bit_1( .a_0(Ain[1]), 
                .b_0(Bin[1]), 
                .sum_0(P[1]), 
                .c_out_0(G[1]));
        
HA_0 add_bit_2( .a_0(Ain[2]), 
                .b_0(Bin[2]), 
                .sum_0(P[2]), 
                .c_out_0(G[2]));
        
HA_0 add_bit_3( .a_0(Ain[3]), 
                .b_0(Bin[3]), 
                .sum_0(P[3]), 
                .c_out_0(G[3]));
                
CLA_Gen u4( .P_in(P), 
            .G_in(G), 
            .C_0(Cin),
            .C(cla_wire));

assign sum[3] = P[3] ^ cla_wire[2]; 
assign sum[2] = P[2] ^ cla_wire[1];
assign sum[1] = P[1] ^ cla_wire[0];
assign sum[0] = P[0] ^ Cin;
assign Cout = cla_wire[3];


endmodule
