function [res_Vect] = Analysis( x , Fs)

%LPC
a = lpc(x, 16);

%Variance of Residual Signal
% inverse_filt = [1, -a(2:end)];
res = filter(a, 1, x);
var_sig = var(res);

%Wavelet Transform
[C,L] = wavedec(x,8,'db2');

%Extracting Coefficients of the last four scales
cD4 = detcoef(C,L,4);
cD3 = detcoef(C,L,3);
cD2 = detcoef(C,L,2);
cD1 = detcoef(C,L,1);

%Computing the variances
v1=var(cD1);
v2=var(cD2);
v3=var(cD3);
v4=var(cD4);

Delta_psi2 = [v1,v2,v3,v4];


%Decision of Voiced or Unvoiced
%Algorithm used : ZeroCrossing Detection & Energy of the Sample
voicedStatus = zcr_eng(x, Fs, 10000);

%Pitch period of the Voiced Signal
Tp = 0;
if(voicedStatus)
    c = cceps(x);
    ms2=floor(Fs*0.002); % 2ms
    ms20=floor(Fs*0.02); % 20ms
    [maxi , idx] = max(abs(c(ms2:ms20)));
    Tp = (Fs / (ms2 + idx - 1))^-1;
end

%result Vector is as follows :

res_Vect = [a, var_sig, Delta_psi2, voicedStatus, Tp];


end

