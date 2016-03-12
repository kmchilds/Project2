%Written By:    Kevin Childs
%Course:        ELEN249
%Quarter:       Winter 2016
%Professors:    T. Ogunfunmi & K. Gunnam
%Comments:      Created using the paper, but did not work correctly.
function [p,v] = twoBitLZD(a0,a1)
p = and(not(a1),a0);
v = or(a0,a1);
end

