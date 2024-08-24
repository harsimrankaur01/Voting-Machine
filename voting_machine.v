module voting_machine #(
    parameter IDLE = 2'b00,				
    parameter VOTE = 2'b01,
    parameter HOLD = 2'b10,
    parameter FINISH = 2'b11
)(
    input clk,							
    input rst,						
    input cand1_vote,				
    input cand2_vote,				
    input cand3_vote,				
    input voting_done,				

    output reg [31:0] count1,		
    output reg [31:0] count2,		
    output reg [31:0] count3		
);	  

reg [31:0] prev_cand1_vote;				
reg [31:0] prev_cand2_vote;				
reg [31:0] prev_cand3_vote;				

reg [31:0] counter1;					
reg [31:0] counter2;					
reg [31:0] counter3;					

reg [1:0] current_state, next_state;	
reg [3:0] hold_counter;                    

always @(posedge clk or negedge rst) begin
    case (current_state)													
        IDLE: if (!rst) begin
                next_state <= VOTE;									
                counter1 <= 32'b0;									
                counter2 <= 32'b0;
                counter3 <= 32'b0;
                hold_counter <= 4'b0000;
            end else begin
                next_state <= IDLE;									
            end

        VOTE: if (voting_done == 1'b1) begin
                next_state <= FINISH;								
            end else if (cand1_vote == 1'b0 && prev_cand1_vote == 1'b1) begin
                counter1 <= counter1 + 1'b1;							
                next_state <= HOLD;									
            end else if (cand2_vote == 1'b0 && prev_cand2_vote == 1'b1) begin
                counter2 <= counter2 + 1'b1;							
                next_state <= HOLD;									
            end else if (cand3_vote == 1'b0 && prev_cand3_vote == 1'b1) begin
                counter3 <= counter3 + 1'b1;							
                next_state <= HOLD;									
            end else begin
                next_state <= VOTE;
            end

        HOLD: if (voting_done == 1'b1) begin
                next_state <= FINISH;								
            end else if (hold_counter != 4'b1111) begin
                hold_counter <= hold_counter + 1'b1;
            end else begin
                next_state <= VOTE;									
            end

        FINISH: if (voting_done == 1'b0) begin
                next_state <= IDLE;									
            end else begin
                next_state <= FINISH;									
            end

        default: begin 
            counter1 <= 32'b0;										
            counter2 <= 32'b0;
            counter3 <= 32'b0;
            hold_counter <= 4'b0000;
            next_state <= IDLE;									
        end
    endcase
end	  

always @(posedge clk or negedge rst) begin				
    if (rst == 1'b1) begin
        current_state <= IDLE;										
        count1 <= 32'b0; 											
        count2 <= 32'b0;
        count3 <= 32'b0;
        hold_counter <= 4'b0000;
    end else if (rst == 1'b0 && voting_done == 1'b1) begin
        count1 <= counter1; 										
        count2 <= counter2;
        count3 <= counter3;
    end else begin
        current_state <= next_state;								
        prev_cand1_vote <= cand1_vote;								
        prev_cand2_vote <= cand2_vote;
        prev_cand3_vote <= cand3_vote;
    end
end	

endmodule
