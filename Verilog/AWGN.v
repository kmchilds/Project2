module awgn (clk, reset, urng_seed1, urng_seed2, awgn_out);
 `include "sqrt32.v"
 `include "getCosine.v"

input clk,reset;
input [31:0] urng_seed1,urng_seed2;
output awgn_out;

wire [31:0] a,b;

assign a = urng_seed1;
assign b = urng_seed2;

wire [47:0] u0;
wire [15:0] u1;

assign u0 = {a[31:0], b[31:16]};
assign u1 = b[15:0];

//code for log: e = -2ln(u0)

wire [31:0] e_temp, e;
assign e_temp = -1*clog2(u0);
assign e = e_temp << 1;

//code for sqrt: f = sqrt(e)

wire [17:0] f;
sqrt32(clk, 1, 1, e, f);
//assign f = sqrt32(clk, reset, e);

//sin: g0 = sin(2*pi*u1) and g1 = cos(2*pi*u1)

wire [15:0] g0,g1;
getCosine(clk,u1,g0,g1);

//finding x0 and x1

wire [15:0] x0,x1;

assign x0 = f*g0;  // need to work on this so bits line up correctly
assign x1 = f*g1;  // need to work on this so bits line up correctly


endmodule