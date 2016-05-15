#file_name='shelter.wav';
#file_name='track.wav';
file_name='la-do-mi-la.wav';
#file_name='pepel.wav';
#file_name='samples/a2m.ogg';
song=audioread(file_name);
Fs=audioinfo(file_name).SampleRate;

#{
Fs=44100; % sampling frequency
f0=167; % Hz frequency of sinusoid
l=0; r=10; % time period in seconds
t=[l:1/Fs:r]; % discrete time
song=0.8*sin(2*pi*f0*t); % generated signal
#}

#l=max(1,round(Fs*0.133));
#r=min(length(song),round(Fs*0.2));
l=1;
r=length(song);
lb=1;
hb=300;

x=song(l:r);

MULT_SIZE=4;
MULT_TIME=16;

Size=2048*MULT_SIZE;

WP=[];
WA=[];
NMP=[];
NMA=[];

for k=1:Size/MULT_TIME:length(x)
  bs=postpad(x(k:min(k+Size,length(x))),Size);

  c=fft(postpad(bs,2*Size))/Size;
  hc=c(1:Size);
  nmp=20*log10(abs(hc));
  WP=(0:length(nmp)-1)*Fs/length(nmp)/2;
  NMP=[NMP; nmp];


  [ha,wa] = freqz(bs,1,length(bs),Fs);
  WA=wa;
  nma=20*log10(abs(ha));
  NMA=[NMA; nma'];
end


#{
[lt,nw]=size(NMA);
HB=round(nw*hb*2/Fs);
LB=round(nw*lb*2/Fs)+1;
T=(1:lt)*Size/Fs/MULT_TIME;

#subplot(212);
figure(1); mesh(T,WA(LB:HB),NMA(:,LB:HB)');
#}

[lt,nw]=size(NMP);
HB=round(nw*hb*2/Fs);
LB=round(nw*lb*2/Fs)+1;
T=(0:lt-1)*Size/Fs/MULT_TIME;
#subplot(211);
figure(2); mesh(T,WP(LB:HB),NMP(:,LB:HB)');

figure(3); plot(WP(LB:HB),mean(NMP(:,LB:HB)));
#set(gca,'xscale','log'); output_precision(0);
