%Written By:    Kevin Childs
%Course:        ELEN249
%Quarter:       Winter 2016
%Professors:    T. Ogunfunmi & K. Gunnam
%Comments:      Created to find the leading zero.  In order to implement
%               this in hardware, I would have done more shift and compares
%               rather than a loop that checks, but it is essentially the
%               same process.  This is not optimal for hardware
%               implementation.
function y = leadingZeroDetector(x)
x = bitget(x,fliplr([1:length(bin(x))]));
LZD = 0;
i=1;
while(i~=length(x))
    if(x(i)>0)
        LZD = [LZD,i];
    end
    i=i+1;
end
if(length(LZD)>1)
    LZD = min(LZD(2:length(LZD)))-1;
end
y = fi(LZD,1,length(x),0);
        
end

