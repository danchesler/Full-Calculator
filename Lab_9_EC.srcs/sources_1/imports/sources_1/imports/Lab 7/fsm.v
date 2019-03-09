`timescale 1ns / 1ps

module fsm( input clk, go,
            input [1:0] op,
            output reg WE, REA, REB, S2,
            output reg [1:0] S1, WA, RAA, RAB, C,
            output reg [3:0] CS,
            output reg Done);
            
reg [3:0] state = 0;
  
always @(posedge clk)
begin
    case(state)
        0://idle case
        begin
        S1 <= 0; WE <= 0; REA <= 0;
        REB <= 0; C <= 0; S2 <= 0;
        WA <= 0; RAA <= 0; RAB <= 0;
        CS <= 0; Done <= 0;
        if(go == 1) state = 1;
        end
        
        1://read in value 1
        begin
        
        S1 <= 3; WE <= 1; REA <= 0;
        REB <= 0; C <= 0; S2 <= 0;
        WA <= 1; RAA <= 0; RAB <= 0;
        CS <= 1; Done <= 0;
        state = 2;
        end
        
        2://read in value 2, then read op
        begin
        S1 <= 2; WE <= 1; REA <= 0;
        REB <= 0; C <= 0; S2 <= 0;
        WA <= 2; RAA <= 0; RAB <= 0;
        CS <= 2; Done <= 0;
        case(op)
            3: state = 6;
            2: state = 5;
            1: state = 4;
            default: state = 3;
        endcase
        end
        
        3://add case
        begin
        S1 <= 0; WE <= 1; REA <= 1;
        REB <= 1; C <= 0; S2 <= 0;
        WA <= 3; RAA <= 1; RAB <= 2;
        CS <= 3; Done <= 0;
        state = 7;
        end        
        
        4://sub case
        begin
        S1 <= 0; WE <= 1; REA <= 1;
        REB <= 1; C <= 1; S2 <= 0;
        WA <= 3; RAA <= 1; RAB <= 2;
        CS <= 4; Done <= 0;
        state = 7;
        end
        
        5://and case
        begin
        S1 <= 0; WE <= 1; REA <= 1;
        REB <= 1; C <= 2; S2 <= 0;
        WA <= 3; RAA <= 1; RAB <= 2;
        CS <= 5; Done <= 0;
        state = 7;
        end
        
        6://xor case
        begin
        S1 <= 0; WE <= 1; REA <= 1;
        REB <= 1; C <= 3; S2 <= 0;
        WA <= 3; RAA <= 1; RAB <= 2;
        CS <= 6; Done <= 0;
        state = 7;
        end       
        
        7://Done case
        begin
        S1 <= 0; WE <= 0; REA <= 0;
        REB <= 1; C <= 0; S2 <= 1;
        WA <= 0; RAA <= 0; RAB <= 3;
        CS <= 7; Done <= 1;
        state = 0;
        end  
        
        default: state = 0; //shouldnt happen, but if it does, idle state
        endcase
end
endmodule