function y_s2= Synthesis(tw, Nw, fs, Code_Vector)

if (Code_Vector(23))
%Voiced
%generating glottal pulses
Tp=Code_Vector(24);    %Pitch Period
r_s = glottis(Tp, tw, fs);

else
%Unvoiced
%generating Gaussian white noise 
var_r=Code_Vector(18);
r_s = sqrt(var_r).*randn(1,Nw); 

end

%vocal tract filter
y_s1 = filter(1, Code_Vector(1:17), r_s);

%Wavelet adjustment
%Performing an 8 level Wavelet Decomposition of a Signal
[C,L] = wavedec(y_s1',8,'db2');

%Extracting Coefficients of the last four scales
cD4 = detcoef(C,L,4);
cD3 = detcoef(C,L,3);
cD2 = detcoef(C,L,2);
cD1 = detcoef(C,L,1);

%Computing the variances
v1a=var(cD1);
v2a=var(cD2);
v3a=var(cD3);
v4a=var(cD4);

%Wavelets of the origianl signal
v=Code_Vector(19:22);

%Variance adjustment
cD1a=sqrt(v(1)).*(cD1./sqrt(v1a));
cD2a=sqrt(v(2)).*(cD2./sqrt(v2a));
cD3a=sqrt(v(3)).*(cD3./sqrt(v3a));
cD4a=sqrt(v(4)).*(cD4./sqrt(v4a));

%Inverse DWT
L1=sum(L(1:5));
L2=sum(L(6:9));
C(L1+1:L1+L2)=[cD4a; cD3a; cD2a; cD1a];

y_s2 = waverec(C,L,'db2');

