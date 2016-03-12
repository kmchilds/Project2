%Written By:    Kevin Childs
%Course:        ELEN249
%Quarter:       Winter 2016
%Professors:    T. Ogunfunmi & K. Gunnam
%Comments:      This is the test bench of the AWGN.m function.  It
%               generates the necessary input seeds using the taus.m
%               function and plots the output of the AWGN.m file with a
%               certain number of iterations as outlined in the code.
%               Unfortunately, time didn't permit to implement the reset or
%               clk parameters, but rather than giving it a clk and kill
%               (reset) command, in this simulation I used a certain number
%               of iterations.  Sorry, time became too short after my
%               defeat with System Generator.
i=0;
results = [];
while(i<1000) %500 iterations used to give sufficient data to get a decent plot.
    a = taus();
    b = taus();
    [x0,x1] = AWGN(0,1,a,b);
    results = [results;x0,x1];%building an array with values from AWGN
    i = i + 1;
end
plot (results)%plot of results
