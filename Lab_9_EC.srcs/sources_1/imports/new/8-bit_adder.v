`timescale 1ns / 1ps

module bit8_adder(  input [7:0] A, B,
                    input Cin,
                    output [7:0] sum     
                    );
                    
wire store_cout;

Adder_mod add3to0(  .Ain(A[3:0]), 
                    .Bin(B[3:0]), 
                    .Cin(Cin),
                    .sum(sum[3:0]),
                    .Cout(store_cout)   );

Adder_mod add7to4(  .Ain(A[7:4]), 
                    .Bin(B[7:4]),
                    .Cin(store_cout),
                    .sum(sum[7:4])    );

endmodule
