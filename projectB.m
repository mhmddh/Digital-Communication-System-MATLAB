% Part B: PAM with Hamming pulse shaping.
clear; clc;
order = input('PAM order (2, 4, or 16): ');
eb = input('Eb/N0 in dB: ');
assert(any(order==[2 4 16]),'Invalid PAM order.');
k=log2(order); bits=randi([0 1],10000*k,1);
r=dc_simulate(bits,'pam',order,eb,'hamming',0.5);
fprintf('%d-PAM, Eb/N0 %.2f dB: BER %.6g, SER %.6g\n',order,eb,r.ber,r.ser);
figure; plot(real(r.rxSymbols),'.'); xlabel('Symbol'); ylabel('Amplitude'); title(sprintf('%d-PAM received samples',order));
