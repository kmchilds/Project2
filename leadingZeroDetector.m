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

