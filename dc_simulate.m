function result = dc_simulate(bits, scheme, order, ebn0db, pulse, beta)
%DC_SIMULATE End-to-end complex-baseband PAM/QAM AWGN simulation.
% No toolboxes required. One sample per symbol is used for decisions after
% pulse shaping, AWGN, and matched filtering at 10 samples/symbol.
if nargin < 6, beta = 0.5; end
sps = 10;
k = log2(order);
assert(mod(k,1)==0 && mod(numel(bits),k)==0, 'Bits must form complete symbols.');
bits = double(bits(:));
assert(all(bits==0 | bits==1),'Input must contain binary bits.');
labels = reshape(bits,k,[]).';
weights = 2.^(k-1:-1:0).';
idx = labels*weights;
[const, ~] = constellation(scheme,order);
symbols = const(idx+1);
if strcmpi(pulse,'hamming')
    h = hamming_local(sps);
elseif strcmpi(pulse,'srrc')
    h = srrc_local(beta,5,sps);
else
    error('Pulse must be hamming or srrc.');
end
h = h(:)/norm(h);
upsampled = zeros(numel(symbols)*sps,1);
upsampled(1:sps:end) = symbols;
tx = conv(upsampled,h);
% With unit-energy pulse and unit-average-energy constellation, Es/N0=k*Eb/N0.
% Complex noise variance is N0; for real PAM use real noise variance N0/2.
n0 = 1/(k*10^(ebn0db/10));
if strcmpi(scheme,'pam')
    noise = sqrt(n0/2)*randn(size(tx));
else
    noise = sqrt(n0/2)*(randn(size(tx))+1i*randn(size(tx)));
end
rx = tx + noise;
matched = conv(rx,flipud(conj(h)));
received = matched(numel(h):sps:numel(h)+(numel(symbols)-1)*sps);
[~,closest] = min(abs(bsxfun(@minus,received,const.')).^2,[],2);
detectedIdx = closest-1;
detectedBits = zeros(numel(bits),1);
for b = 1:k
    detectedBits(b:k:end) = bitget(uint32(detectedIdx),k-b+1);
end
result.ber = mean(detectedBits~=bits);
result.ser = mean(detectedIdx~=idx);
result.bits = detectedBits;
result.txSymbols = symbols;
result.rxSymbols = received;
result.constellation = const;
result.ebn0db = ebn0db;
result.scheme = upper(scheme);
result.order = order;
result.pulse = pulse;
end

function [c,k] = constellation(scheme,m)
k = log2(m);
if strcmpi(scheme,'pam')
    assert(any(m==[2 4 16]),'PAM orders: 2, 4, 16.');
    c = (-(m-1):2:(m-1)).';
elseif strcmpi(scheme,'qam')
    assert(any(m==[4 8 16]),'QAM orders: 4, 8, 16.');
    if m==8
        % Rectangular 4x2 QAM; row-major mapping.
        [xx,yy] = meshgrid([-3 -1 1 3],[-1 1]);
    else
        side = sqrt(m);
        levels = -(side-1):2:(side-1);
        [xx,yy] = meshgrid(levels,levels);
    end
    c = xx(:)+1i*yy(:);
else
    error('Scheme must be PAM or QAM.');
end
c = c/sqrt(mean(abs(c).^2));
end

function h = hamming_local(n)
t = (0:n-1).';
h = 0.54-0.46*cos(2*pi*t/(n-1));
end

function h = srrc_local(beta,span,sps)
assert(beta>0 && beta<=1,'Beta must be in (0,1].');
t = (-span*sps:span*sps).' / sps;
h = zeros(size(t));
for n=1:numel(t)
    x=t(n);
    if abs(x)<1e-12
        h(n)=1+beta*(4/pi-1);
    elseif abs(abs(x)-1/(4*beta))<1e-10
        h(n)=beta/sqrt(2)*((1+2/pi)*sin(pi/(4*beta))+(1-2/pi)*cos(pi/(4*beta)));
    else
        h(n)=(sin(pi*x*(1-beta))+4*beta*x*cos(pi*x*(1+beta)))/(pi*x*(1-(4*beta*x)^2));
    end
end
end
