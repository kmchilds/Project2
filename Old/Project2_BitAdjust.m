%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         generate u0 and u1                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = taus();
b = taus();
u0 = bitconcat(a,bitconcat(bitget(b,fliplr([1:15]))));%putting bits together for u0
u1 = bitconcat(bitget(b,fliplr([17:31])));
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
%                    Degree-2 piecewise polynomial                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_e = -log(data(x_e)); % need to put natural log cordic in for this

%Range Reconstruction

ln2 = fi(log(2),1,32,24);
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
%                    Degree-1 piecewise polynomial                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_f = fi(sqrt(x_f),1,31,24);% must change this to a cordic

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
%                   Degree-1 piecewise polynomial                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x,y,g0] = cordic_SinCos(2*pi*x_g_a,16,15,16);
[x,y,g1] = cordic_SinCos(2*pi*x_g_b,16,15,16);

x0 = fi(data(f)*data(g0),0,16,11);
x1 = fi(data(f)*data(g1),0,16,11);

x0 = data(x0)
x1 = data(x1)
