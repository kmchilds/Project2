module awgn2 (clk, reset, urng_seed1, urng_seed2, awgn_out);

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
cordic_1 mySquareRoot (
  .aclk(aclk),                                        // input wire aclk
  .s_axis_cartesian_tvalid(s_axis_cartesian_tvalid),  // input wire s_axis_cartesian_tvalid
  .s_axis_cartesian_tdata(e),    // input wire [15 : 0] s_axis_cartesian_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),            // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(f)   );           // output wire [15 : 0] m_axis_dout_tdata

//sin: g0 = sin(2*pi*u1) and g1 = cos(2*pi*u1)

cordic_0 myCos (
  .s_axis_phase_tvalid(s_axis_phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(u1),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),    // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(g0) );     // output wire [31 : 0] m_axis_dout_tdata

cordic_0 mySin (
  .s_axis_phase_tvalid(s_axis_phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata((1-2^-14)-u1),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),    // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(g1)  );    // output wire [31 : 0] m_axis_dout_tdata

//finding x0 and x1

wire [15:0] x0,x1;

assign x0 = f*g0;  // need to work on this so bits line up correctly
assign x1 = f*g1;  // need to work on this so bits line up correctly

endmodule