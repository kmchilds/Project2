function [p,v] = sixteenBitLZD(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15)
[p1,v1] = eightBitLZD(a0,a1,a2,a3,a4,a5,a6,a7);
[p2,v2] = eightBitLZD(a8,a9,a10,a11,a12,a13,a14,a15);
if (v2)
    mux = p2;
else
    mux = p1;
end
p = [not(v2),mux];
v = or(v1,v2);
end


