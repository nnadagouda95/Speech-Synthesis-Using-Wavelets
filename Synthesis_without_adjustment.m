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
y_s2 = filter(1, Code_Vector(1:17), r_s);


