`timescale 1ns / 1ps

module int_divider( input [3:0] X, Y,
                    input   clk, rst, 
                            R_sl, R_sr, R_ld,       //R_reg
                            X_sl, X_ld,       //X_reg
                            Y_ld,                   //Y_reg
                            sel_Reg, sel_R, sel_Q, sel_Rin,  //muxes
                            ce, c_ld,           //ud_counter     
                    output [3:0] R, Q,              //mux_R and mux_Q outputs     
                    output [2:0] count_out,
                    output R_lt_Y, Y_zero, CNT_zero,   
                    //check reg outputs
                    output [4:0] RregOut,
                    output [3:0] XregOut, YregOut,  
                    //check X_ld          
                    output X_ld_out
                   );

wire Rin_val;
wire [4:0] Rout; //output of R_reg 
wire [3:0] Xout; //output of X_reg 
wire [3:0] Yout; //output of Y_reg 
wire [3:0] SUBout; //subtraction output from subtractor mod
wire [4:0] SUBin = {Rout[4], SUBout}; //concatenate Rout[4] and SUBout to put in mux_R_reg
wire [4:0] R_Reg_in; //output of mux_R_reg

//Instantiated modules  

//Mux for R_Reg
mux2 mux_R_reg( .a(SUBin), .b(5'b0), .sel(sel_Reg), .out(R_Reg_in) ); 

//Outputs R, Q, and Rin
mux2 #(4) mux_R( .a(Rout[3:0]), .b(4'b0), .sel(sel_R) , .out(R) ); 
mux2 #(4) mux_Q( .a(Xout), .b(4'b0), .sel(sel_Q), .out(Q) );  
mux2 #(1) mux_Rin( .a(1'b1), .b(1'b0), .sel(sel_Rin), .out(Rin_val) ); //for X_reg 

//check if Y == 0
Y_check mod_Y( .Y(Y), .out(Y_zero) );

//check if CNT = 0
CNT_zero cnt_mod( .CNT_IN(count_out), .out(CNT_zero) );

//compare R_reg and Y
comparator comp( .a(Rout[3:0]), .b(Yout), .y(R_lt_Y) ); 
                            
shift_register R_reg( .CLK(clk), .RST(rst), 
                    .SL(R_sl), .SR(R_sr), .LD(R_ld), .LeftIn(1'b0), .RightIn(Xout[3]), 
                    .D(R_Reg_in), .Q(Rout) );

shift_register #(4) X_reg(  .CLK(clk), .RST(rst), 
                .SL(X_sl), .SR(1'b0), .LD(X_ld), .LeftIn(1'b0), .RightIn(Rin_val), 
                .D(X), .Q(Xout) );

shift_register #(4) Y_reg(  .CLK(clk), .RST(rst), 
                .SL(1'b0), .SR(1'b0), .LD(Y_ld), .LeftIn(1'b0), .RightIn(1'b0), 
                .D(Y), .Q(Yout) );

//R[3:0] - Y
subtractor sub_mod( .a(Rout[3:0]), .b(Yout), .c(SUBout) ); 

//start at 4, ends at 0
ud_counter ud_mod(  .clk(clk), .rst(rst), .ce(ce), .ld(c_ld), .ud(1'b0), 
                    .D(3'b100),
                    .Q(count_out) );


endmodule
