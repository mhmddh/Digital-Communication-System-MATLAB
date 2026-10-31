%idsys.m:  idealized transmission system

%TRANSMITTER
% encode text string as T-spaced 4-PAM sequence
 
Ma = input('Which constellation you want to select 2PAM , 4PAM , 16PAM ? please enter 2 for 2PAM 4 FOR 4PAM 16 for 16PAM  ');

prompt2 = 'How much is the Energie per bit ? please enter an integer with positive sign !!';
EbN0 = input(prompt2);

    m=(2*floor(Ma*rand(1,10000))-Ma+1)


N=length(m);%sar aande 10000
M=1000;  % oversampling fact

mup=zeros(1,N*M);             % 100000
mup(1:M:N*M)=m; 
p=hamming(M);                 % blip pulse of width M
x=filter(p,1,mup);            % convolve pulse shape with data
figure(1), plotspec(x,1/M)    % baseband AM modulation
t=1/M:1/M:length(x)/M;        % T/M-spaced time vector
fc=20;                        % carrier frequency
c=cos(2*pi*fc*t);             % carrier
r=c.*x;  % modulate message with carrier

%RECEIVER
% am demodulation of received signal sequence r
%u=pam(N,2,1);
 
k=log2(Ma); 
sigma = sqrt(1/(2*k*10^(EbN0/10)));
r=r+sigma*(randn(size(r)));
c2=cos(2*pi*fc*t);             % synchronized cosine for mixing
x2=r.*c2;                      % demod received signal
fl=50; fbe=[0 0.1 0.2 1];      % LPF parameters 
damps=[1 1 0 0 ]; 
b=firpm(fl,fbe,damps);         % create LPF impulse response
x3=2*filter(b,1,x2);           % LPF and scale signal
% extract upsampled pulses using correlation implemented 
% as a convolving filter; filter with pulse and normalize
y=xcorr(x3,p)/(pow(p)*M);
% set delay to first symbol-sample and increment by M
z=y(0.5*fl+N*M:M:2*N*M-1);          % downsample to symbol rate
figure(2), plot([1:length(z)],z,'.') % plot soft decisions
% decision device and symbol matching performance assessment



mprime=pam(N,Ma,1);

newm=m'; 

msg_bin = zeros(1,80000);
rec_bin =zeros(1,80000);
dif_bin =zeros(1,80000);
msg_bin = dec2bin(typecast(int8(newm),'uint8'));
rec_bin=dec2bin(typecast(int8(mprime),'uint8'));
dif_bin= rec_bin-msg_bin;
difsum=sum(abs(dif_bin));
total=sum(difsum);
biterror=total/80000

%f =berawgn(EbN0,'pam',Ma)

lmp=length(mprime);
pererr=100*sum(abs(sign(mprime-m(1:lmp))))/lmp, % symbol error