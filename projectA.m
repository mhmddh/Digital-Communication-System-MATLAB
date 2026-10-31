%idsys.m:  idealized transmission system

%TRANSMITTER
% encode text string as T-spaced 4-PAM sequence

sigma = input('Please select a value for Sigma (Noise)');
str='01234 I wish I were an Oscar Meyer wiener 56789';
m=letters2pam(str); N=length(m); % 4-level signal of length N
% zero pad T-spaced symbol sequence to create upsampled
% T/M-spaced sequence of scaled T-spaced pulses (T=1)
M=100;                        % oversampling factor
mup=zeros(1,N*M);             % Hamming pulse filter with 
mup(1:M:N*M)=m;               % T/M-spaced impulse response
p=hamming(M);                 % blip pulse of width M
x=filter(p,1,mup);            % convolve pulse shape with data
figure(1), plotspec(x,1/M)    % baseband AM modulation
t=1/M:1/M:length(x)/M;        % T/M-spaced time vector
fc=20;                        % carrier frequency
c=cos(2*pi*fc*t);             % carrier
r=c.*x;  % modulate message with carrier

r=r+sigma*(randn(size(r))); %add AWGN noise !!!!
%RECEIVER
% am demodulation of received signal sequence r
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
mprime=quantalph(z,[-3,-1,1,3])'; % quantize alphabet
cvar=(mprime-z)*(mprime-z)'/length(mprime), % cluster variance
lmp=length(mprime);


% decode decision device output to text string
reconstructed_message=pam2letters(mprime)

msg_bin = zeros(1,376);
rec_bin =zeros(1,376);
dif_bin =zeros(1,376);
msg_bin = dec2bin(str);
rec_bin=dec2bin(reconstructed_message);
dif_bin= rec_bin-msg_bin;
difsum=sum(abs(dif_bin));
total=sum(difsum);
biterror=total/376,
%for i=1:366
 %   dif_bin(i)=abs(rec_bin(i)-msg_bin(i));
%end

 pererr=100*sum(abs(sign(mprime-m(1:lmp))))/lmp, % symbol error
 
 
