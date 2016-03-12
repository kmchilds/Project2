function y = taus()
%initializing seeds
s0 = (2^33)*rand(1)-2^32;
s1 = (2^33)*rand(1)-2^32;
s2 = (2^33)*rand(1)-2^32;
%s0=s(1); s1=s(2); s2=s(3);
s0 = fi(s0,1,32,0);
s1 = fi(s1,1,32,0);
s2 = fi(s2,1,32,0);
%taus equations as per figure 3 of paper
b = (bitsrl(bitxor(bitsll(s0,13),s0),19));
s0 = bitxor(bitsll(bitand(s0,fi(hex2dec('fffffffe'),1,32,0)),12),b);
b = (bitsrl(bitxor(bitsll(s1,2),s1),25));
s1 = bitxor(bitsll(bitand(s1,fi(hex2dec('fffffff8'),1,32,0)),4),b);
b = (bitsrl(bitxor(bitsll(s2,3),s2),11));
s2 = bitxor(bitsll(bitand(s2,fi(hex2dec('fffffff0'),1,32,0)),17),b);
y = bitxor(s0,bitxor(s1,s2));
end

