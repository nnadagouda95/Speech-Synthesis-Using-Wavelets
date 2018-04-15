clc;
clear all;

[input_sig_Main, Fs] = audioread('speech.wav');
N=length(input_sig_Main);

tw = 0.02;               %Window duration = 20ms
to = 0.01;               %Overlap duration = 10ms
Nw = tw * Fs;            %Samples in Window
No = floor(to * Fs);     %Samples Overlapped
cnt = 0;
win = hamming(Nw);

ys=[];
%zeros(N,1);

while(length(input_sig_Main) >= ((Nw - No) * (cnt + 1) + No))
    
    y = input_sig_Main(((cnt * (Nw - No) + 1)):((cnt+1)*(Nw-No) + No)  );   %Extraction of a Part of the Signal
    y1 = y.*win;                                                             %Windowing
    
    %pre-emphasizing
    h=[1, -0.9375];
    es=filter(h, 1, y1);
    
    %Analysis    
    Code_Vector = Analysis(es, Fs);
    %Code_Vector is structured as follows
    %   [1 : 17]   -    LPC Coefficiets
    %   [18]       -    Signal Variance 
    %   [19 : 22]  -    Variances of the DWT coefficients
    %   [23]       -    Unvoiced(0)/voiced(1) Status. Boolean Scalar
    %   [24]       -    Pitch Period of the windowed signal to generate
    %                   impulse train excitation.
     
    %Synthesis 
    y2 = Synthesis(tw, Nw, Fs, Code_Vector);
       
    % Apply the de-emphasis filter
    ds=filter(1, h, y2);
    
    if(cnt>1)
    ys=[ys(1:end-No); (ys(end-No+1:end)+ds(1:No)); ds(No+1:end)];
    else
    ys=ds;
    end
    
    cnt = cnt + 1;
end

figure()
subplot(2,1,1)
plot(input_sig_Main)
subplot(2,1,2)
plot(ys)

audiowrite('file.wav', ys, Fs);



