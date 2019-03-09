`timescale 1ns / 1ps

module AND_mod( input [3:0] A, 
                input B,
                output reg [3:0] and_out );
                
always @ (*)
begin 

    and_out[3] = A[3] & B;
    and_out[2] = A[2] & B;
    and_out[1] = A[1] & B;
    and_out[0] = A[0] & B;

end               
endmodule
