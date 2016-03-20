module tb_awgn (reset, s0, s1, s2, s3, s4, s5);
`include "taus.v" 
`include "awgn.v" 

input reset;
input [31:0] s0,s1,s2,s3,s4,s5;

wire [31:0] urng1;
wire [31:0] urng2;
assign urng1 = taus(s0,s1,s2);
assign urng2 = taus(s3,s4,s5);
assign awgn_out = awgn(0,0,urng1,urng2);

endmodule