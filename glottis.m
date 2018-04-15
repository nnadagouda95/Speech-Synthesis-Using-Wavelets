function inp_sig = glottis(pitch , Tw ,fs )
ncyc=Tw * pitch; %
t=0:pitch/fs:ncyc;
inp_sig=glotlf(0,t);
end