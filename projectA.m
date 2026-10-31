% Part A: 4-PAM text transmission through AWGN.
clear; clc;
sigma = input('Noise standard deviation (e.g. 0.2): ');
assert(isscalar(sigma) && isfinite(sigma) && sigma>=0,'Invalid sigma.');
message = '01234 I wish I were an Oscar Meyer wiener 56789';
bytes = uint8(message);
bits = reshape(dec2bin(bytes,8).'-'0',[],1);
% Here sigma is the standard deviation of the REAL sampled channel noise.
% For 4-PAM, k=2, so N0=2*sigma^2 and Eb/N0=1/(k*N0).
if sigma==0, ebn0 = Inf; else, ebn0 = 10*log10(1/(2*log2(4)*sigma^2)); end
r = dc_simulate(bits,'pam',4,ebn0,'hamming',0.5);
recoveredBytes = uint8(bin2dec(char(reshape(r.bits,8,[]).'+ '0')));
reconstructed_message = char(recoveredBytes.');
fprintf('Original: %s\nRecovered: %s\nBER: %.6g | SER: %.6g\n',message,reconstructed_message,r.ber,r.ser);
figure; plot(real(r.rxSymbols),'.'); title('Received 4-PAM symbol samples'); xlabel('Symbol'); ylabel('Amplitude');
