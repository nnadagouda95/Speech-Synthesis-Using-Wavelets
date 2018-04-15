function status = zcr_eng(sig,Fs,thres)
x=sig;
x = x.';

N = length(x); % signal length
n = 0:N-1;
%ts = n*(1/Fs); % time for signal

% define the window
wintype = 'rectwin';
winlen = 201;
winamp = [0.5,1]*(1/winlen);

% find the zero-crossing rate
zc = zerocross(x,wintype,winamp(1),winlen);

% find the zero-crossing rate
E = energy(x,wintype,winamp(2),winlen);

status = (sum(E)/sum(zc)) > thres;
end