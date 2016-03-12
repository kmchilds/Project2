function [p,v] = fourBitLZD(a0,a1,a2,a3)
[p1,v1] = twoBitLZD(a0,a1);
[p2,v2] = twoBitLZD(a2,a3);
if (v2)
    mux = p2;
else
    mux = p1;
end
p = [not(v2),mux];
v = or(v1,v2);
end

