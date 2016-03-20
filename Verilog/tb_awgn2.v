module tb_awgn2 (reset, s0, s1, s2, s3, s4, s5);
`include "taus.v" 
`include "awgn2.v" 

input reset;
input [31:0] s0,s1,s2,s3,s4,s5;

wire [31:0] urng1;
wire [31:0] urng2;
//assign urng1 = taus(s0,s1,s2);
taus(clk, ce, s0, s1, s2, tausrand);
//assign urng2 = taus(s3,s4,s5);
taus(clk, ce, s3, s4, s5, tausrand);
//assign awgn_out = awgn(0,0,urng1,urng2);
awgn2 (clk, reset, urng_seed1, urng_seed2, awgn_out);

endmodule