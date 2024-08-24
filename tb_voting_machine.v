`timescale 1ns/1ns

module tb_voting_machine();
reg clk;
reg rst;
reg cand1;
reg cand2;
reg cand3;
reg vote_over;

wire [5:0] result1;
wire [5:0] result2;
wire [5:0] result3;

voting_machine uut (
    .clk(clk), 
    .rst(rst), 
    .i_candidate_1(cand1), 
    .i_candidate_2(cand2), 
    .i_candidate_3(cand3), 
    .i_voting_over(vote_over),
    .o_count1(result1),
    .o_count2(result2),
    .o_count3(result3)
);

initial clk = 1'b1;

always #5 clk = ~clk;

initial begin
    $monitor ("time = %d, rst = %b, cand1 = %b, cand2 = %b, cand3 = %b, vote_over = %b, result1 = %3d, result2 = %3d, result3 = %3d",
    $time, rst, cand1, cand2, cand3, vote_over, result1, result2, result3);

    rst = 1'b1;
    cand1 = 1'b0;
    cand2 = 1'b0;
    cand3 = 1'b0;
    vote_over = 1'b0;

    #20 rst = 1'b0;
    #10 cand1 = 1'b1;
    #10 cand1 = 1'b0;

    #20 cand2 = 1'b1;
    #10 cand2 = 1'b0;

    #20 cand1 = 1'b1;
    #10 cand1 = 1'b0;

    #20 cand3 = 1'b1;
    #10 cand3 = 1'b0;

    #20 cand2 = 1'b1;
    #10 cand2 = 1'b0;

    #20 cand2 = 1'b1;
    #10 cand2 = 1'b0;

    #20 cand1 = 1'b1;
    #10 cand1 = 1'b0;

    #20 cand3 = 1'b1;
    #10 cand3 = 1'b0;

    #30 vote_over = 1'b1;

    #50 rst = 1'b1;
    
    #60 $stop;
end

initial begin
    $dumpfile("voting_dumpfile.vcd");
    $dumpvars(0, tb_voting_machine);
end

endmodule
