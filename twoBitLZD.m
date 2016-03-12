function [p,v] = twoBitLZD(a0,a1)
p = and(not(a1),a0);
v = or(a0,a1);
end

