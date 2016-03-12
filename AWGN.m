function [x0,x1] = AWGN(clk,reset,urng_seed1,urng_seed2)
%Written By:    Kevin Childs
%Course:        ELEN249
%Quarter:       Winter 2016
%Professors:    T. Ogunfunmi & K. Gunnam
%Comments:      This program was written to implement a simulation of a
%               hardware design for a Box-Muller Method AWGN.  This
%               implementation is by no means elegant and was started a
%               week before the deadline after discovering that System
%               Generator had a lot of hidden properties making design and
%               simulation difficult.  If I had to start all over, I would
%               select the simplistic Matlab approach and would have had
%               ample time to get all of the intricacies of this code
%               correct.

%This program requires the functions cordic_rotation_kernel.m, 
%cordic_SinCos.m, codic_Sqrt.m, and leadingZeroDetector.m to operate.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         generate u0 and u1                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = urng_seed1; %First 32 bit seed provided by taus.m function.
b = urng_seed2; %Second 32 bit seed provided by taus.m function.
u0 = bitconcat(a,bitconcat(bitget(b,fliplr([1:15]))));%putting bits together for u0
u1 = bitconcat(bitget(b,fliplr([17:31])));%separating b for 16 bit u1 
u0 = fi(data(bitsrl(fi(u0,1,96,48),48)),0,48,48);%converting u0 from 48:0 to 48:48
u1 = fi(data(bitsrl(fi(u1,1,32,16),16)),0,16,16);%converting u1 from 16:0 to 16:16

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         evaluate e = -2ln(u0)                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%range reduction
exp_e = accumpos(leadingZeroDetector(u0),fi(1,0,48,0));
x_e = bitsll(fi(data(u0),0,64,48),exp_e);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                %Approximate -ln(x_e) where x_e= [1,2)              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_e = -log(data(x_e)); %didn't have time to implement a natural log cordic

%Range Reconstruction

ln2 = fi(0.6931,1,32,24);
e_1 = exp_e*ln2;
e = bitsll((accumneg(e_1,y_e)),1);
e = fi(data(e),1,31,24);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         evaluate f = sqrt(e)                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Range Reduction
exp_f = accumneg(fi(5,0,31,24),leadingZeroDetector(e));
exp_f = fi(data(exp_f),1,3,0);
x_f_1 = bitsll(e,exp_f);
if(bitget(exp_f,1))
    x_f = bitsrl(x_f_1,1);
else
    x_f = x_f_1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Approximate sqrt(x_f) where x_f = [1,4)              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mySqrt = cordicsqrt(x_f,32);
y_f = fi(mySqrt,1,31,24);

%Range Reconstruction
if(bitget(exp_f,1))
    exp_f_1 = bitsrl(accumpos(exp_f,fi(1,1,5,0)),1);
else
    exp_f_1 = bitsrl(exp_f ,1);
end

f = bitsll(y_f,exp_f_1);
f = fi(data(f),1,17,13);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Evaluate g0 = sin(2*pi*u1)                    %
%                               g1 = cos(2*pi*u1)                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Range Reduction
quad = bitconcat(bitget(u1,fliplr([15:16])));
x_g_a = fi(bitconcat(bitget(u1,fliplr([1:14]))),0,16,0);
x_g_a = fi(data(bitsrl(fi(data(x_g_a),1,32,16),14)),0,16,15);
x_g_b = fi(1-2^-14-data(x_g_a),0,16,15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Approximate cos(x_g_a*pi/2) and cos(x_g_b*pi/2)         %
%               %where x_g_a, x_g_b = [0,1-2^-14]                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x,y,g0] = cordic_SinCos(2*pi*x_g_a,16,15,16);
[x,y,g1] = cordic_SinCos(2*pi*x_g_b,16,15,16);

x0 = fi(data(f)*data(g0),0,16,11);
x1 = fi(data(f)*data(g1),0,16,11);

x0 = data(x0);
x1 = data(x1);

end

