`timescale 1ns / 1ps

module cu( input clk, go, rst, rlty, CNT, Y,
           output reg   R_sl, R_sr, R_ld, 
           output reg   X_sl, X_ld, 
                        Y_ld, 
           output reg   sel_Reg, sel_R, sel_Q,
           output reg sel_Rin, ce, c_ld,
           output reg Done, Error           );
            
reg [4:0] cs, ns;
reg [13:0] nsOutput;
// { R_sl, R_sr, R_ld, X_sl, X_ld, Y_ld, sel_Reg, sel_R, sel_Q, sel_Rin, ce, c_ld, Done, Error}

parameter idle      = 14'b00000000000000;
parameter load      = 14'b00101100001100;
parameter shiftl0   = 14'b10010000000000;
parameter shiftl1   = 14'b10010000010000;
parameter dec       = 14'b00000000001000;
parameter sub       = 14'b00100010001000;
parameter shiftr0   = 14'b01000000000000;
parameter out       = 14'b00000001100010;
parameter error     = 14'b00000000000001;
parameter s3idle    = 14'b00100010000000;



always @(posedge clk, posedge rst) //sets cs to ns
begin//always
    if(rst) 
    begin//if
    cs <= 0;
    end//if
    else
    cs <= ns;
end//always

always @(cs,rst) //sets output values
begin//always
    if(rst) {R_sl, R_sr, R_ld, X_sl, X_ld, Y_ld, sel_Reg, sel_R, sel_Q, sel_Rin, ce, c_ld, Done, Error} = idle;
    case(cs)
            0://idle case
            begin
                nsOutput = idle;
            if (go) nsOutput = load;
            end
            
            1://load
            begin
            if(Y)
            begin
                {R_sl, R_sr, R_ld, X_sl, X_ld, Y_ld, sel_Reg, sel_R, sel_Q, sel_Rin, ce, c_ld, Done, Error} = error; //mealy output for error
                nsOutput = error;
            end
            else nsOutput = shiftl0;
            end
            
            //wait state for error
            10: nsOutput = error;
            
            2://shift 0 left
                nsOutput = dec;
            
            3://dec
            begin
            if(rlty) nsOutput =  shiftl0;
            else
            begin
                {R_sl, R_sr, R_ld, X_sl, X_ld, Y_ld, sel_Reg, sel_R, sel_Q, sel_Rin, ce, c_ld, Done, Error} = sub;
                nsOutput = s3idle;
            end
            end        
            
            9: nsOutput = shiftl1;
            
            4://shift 1 left
            begin
            if(CNT) nsOutput =  shiftr0;
            else nsOutput = dec;
            end
            
            5://shift 0 left
            begin
            if(CNT) nsOutput =  shiftr0;
            else nsOutput = dec;
            end
            
            6://shift 0 right
            nsOutput = out;
                  
            
            7://out case
            nsOutput = idle;
           
            default://default case, resets state to idle by default
            nsOutput = idle;
        endcase
        {R_sl, R_sr, R_ld, X_sl, X_ld, Y_ld, sel_Reg, sel_R, sel_Q, sel_Rin, ce, c_ld, Done, Error} = nsOutput;
end//always
    
always @(*)//calculates next state & next state output values
begin//always
    case(cs)
        0://idle case
        if (go) ns = 1;
        
        1://load
        begin
        if(Y) ns = 10;
        else ns = 2;
        end
        
        //wait state for error
        10: ns = 0;
        
        2://shift 0 left
        ns = 3;
        
        3://dec
        begin
            if(rlty) ns = 5;
            else ns = 9;
        end        
        
        9: ns = 4;
        
        4://shift 1 left
        begin
        if(CNT) ns = 6;
        else ns = 3;
        end
        
        5://shift 0 left
        begin
        if(CNT) ns = 6;
        else ns = 3;
        end
        
        6://shift 0 right
        ns = 7;     
        
        7://out case
        ns = 0;  
        
        default://default case, resets state to idle by default
        ns = 0;
        
    endcase
end //always
endmodule