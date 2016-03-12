function [p,v] = eightBitLZD(a0,a1,a2,a3,a4,a5,a6,a7)
[p1,v1] = fourBitLZD(a0,a1,a2,a3);
[p2,v2] = fourBitLZD(a4,a5,a6,a7);
if (v2)
    mux = p2;
else
    mux = p1;
end
p = [not(v2),mux];
v = or(v1,v2);
end
