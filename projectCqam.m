% Part C: QAM with SRRC pulse shaping.
clear; clc;
order = input('QAM order (4, 8, or 16): ');
eb = input('Eb/N0 in dB: ');
beta = input('SRRC roll-off beta (e.g. 0.5 or 1): ');
assert(any(order==[4 8 16]),'Invalid QAM order.');
k=log2(order); bits=randi([0 1],10000*k,1);
r=dc_simulate(bits,'qam',order,eb,'srrc',beta);
fprintf('%d-QAM SRRC beta %.2f, Eb/N0 %.2f dB: BER %.6g, SER %.6g\n',order,beta,eb,r.ber,r.ser);
figure; plot(real(r.rxSymbols),imag(r.rxSymbols),'.'); axis equal; grid on; xlabel('I'); ylabel('Q'); title('QAM with SRRC');
