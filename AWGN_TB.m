i=0;
results = [];
while(i<500)
    a = taus();
    b = taus();
    [x0,x1] = AWGN(0,1,a,b);
    results = [results;x0,x1];
    i = i + 1;
end
plot (results)
