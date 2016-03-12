function [p,v] = thirtytwoBitLZD(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,...
a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31)
[p1,v1] = sixteenBitLZD(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15);
[p2,v2] = sixteenBitLZD(a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31);
if (v2)
    mux = p2;
else
    mux = p1;
end
p = [not(v2),mux];
v = or(v1,v2);
end


