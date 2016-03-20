//////////////////////////////////////////////////////////
//														//
//			Written By: Kevin Childs					//
//			Class:		ELEN 249						//
//			Professor:	K. Gunnam & T. Ogunfunmi		//
//			Quarter:	Winter 2016						//
//			Module:		Tausworthe_URNG					//
//			Notes:		Creates a more random number.	//
//														//
//////////////////////////////////////////////////////////


module taus(clk, ce, s0, s1, s2, tausrand);
input clk, ce;
input [31:0] s0, s1, s2;
output reg [31:0] tausrand;

wire [31:0] b0,b1,b2;
//always @(posedge clk)
//begin
assign b0 = (((s0 << 13) ^ s0) >> 19);
assign s0 = (((s0 & 32'hFFFFFFFE) << 12) ^ b0);
assign b1 = (((s0 << 2) ^ s1) >> 25);
assign s1 = (((s1 & 32'hFFFFFFF8) << 4) ^ b1);
assign b2 = (((s2 << 3) ^ s2) >> 11);
assign s2 = (((s2 & 32'hFFFFFFF0) << 17) ^ b2);


always @(posedge clk)
begin
tausrand<=s0 ^ s1 ^ s2;
end

endmodule

