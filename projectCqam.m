%idsys.m:  idealized transmission system

%TRANSMITTER
% encode text string as T-spaced 4-PAM sequence
Ma = input('Which constellation you want to select 4QAM , 8QAM , 16QAM ? please enter 4 for 4QAM 8 FOR 8QAM 16 for 16QAM  ');
prompt2 = 'How much is the Energie per bit ? please enter an integer with positive sign !!';
EbN0 = input(prompt2);
j=sqrt(-1);
if Ma==4
    m=(2*floor(2*rand(1,10000))-2+1+sign(randn(1,1))*j*(2*floor(2*rand(1,10000))-2+1));
end

if Ma==8
    m=(2*floor(4*rand(1,10000))-4+1+sign(randn(1,1))*j*(2*floor(4*rand(1,10000))-4+1));
end

if Ma==16
    m=(2*floor(8*rand(1,10000))-8+1+sign(randn(1,1))*j*(2*floor(8*rand(1,10000))-8+1));
end
N=length(m);%sar aande 10000
M=10;  % oversampling fact


Ts=.0001; j=sqrt(-1);   % # symbols, oversampling factor
time=Ts*(N*M-1); t=0:Ts:time; 
fc=1000; th=-1.0;   
mup=zeros(1,N*M);             % 100000
mup(1:M:N*M)=m; 
p=srrc(5,0.5,M);                % blip pulse of width M
x=filter(p,1,mup);            % convolve pulse shape with data
v=real(x.*exp(j*(2*pi*fc*t+th)));     % complex carrier
EbN0=1; 
k=log2(Ma); 
sigma = sqrt(1/(2*k*10^(EbN0/10)));
v = v+sigma*sign(randn(size(v)));
%RECEIVER
% am demodulation of received signal sequence r
f0=1000; ph=-1.0;  
v2=v.*exp(-j*(2*pi*f0*t+ph));  % demodulate v
l=50; f=[0,0.2,0.25,1]; a=[1 1 0 0];   % specify filter parameters
b=firpm(l,f,a);                        % design filter
s=2*filter(b,1,v2);
figure(1), plotspec(s,1/M)    % baseband AM modulation                 
         % LPF and scale signal
% extract upsampled pulses using correlation implemented 
% as a convolving filter; filter with pulse and normalize
y=xcorr(s,p)/(pow(p)*M);
% set delay to first symbol-sample and increment by M
z=y(0.5*l+N*M:M:2*N*M-1);          % downsample to symbol rate
figure(2), plot(real(x))
title('real part')
figure(3), plot(imag(x))% plot soft decisions
title('imaginary part')
% decision device and symbol matching performance assessment

if Ma==4
   mprime=(pam(N,2,1)+j*pam(N,2,1)); %4*4QAM it is 16 QAM 
end

if Ma==8
  mprime= 2*((pam(N,4,1)+j*pam(N,4,1))); %4*4QAM it is 16 QAM 
end

if Ma==16
   mprime=4*((pam(N,8,1)+j*pam(N,8,1))); %4*4QAM it is 16 QAM 
end
%cvar=(mprime-z)*(mprime-z)'/length(mprime), % cluster variance
lmp=length(mprime);

newm=m'; 

msgreal_bin = zeros(1,80000);
recreal_bin =zeros(1,80000);
msgimag_bin = zeros(1,80000);
recimag_bin =zeros(1,80000);
dif_bin =zeros(1,80000);
msgreal_bin = dec2bin(typecast(int8(real(newm)),'uint8'));
recreal_bin=dec2bin(typecast(int8(real(mprime)),'uint8'));
msgimag_bin = dec2bin(typecast(int8(imag(newm)),'uint8'));
recimag_bin=dec2bin(typecast(int8(imag(mprime)),'uint8'));
difreal_bin= recreal_bin-msgreal_bin;
difrealsum=sum(abs(difreal_bin));
difimag_bin= recimag_bin-msgimag_bin;
difimagsum=sum(abs(difimag_bin));
totalreal=sum(difrealsum);
totalimag=sum(difimagsum);
biterror=(totalreal+totalimag)/160000

pererr=100*sum(abs(sign(mprime-m(1:lmp))))/lmp, % symbol error
% decode decision device output to text string
