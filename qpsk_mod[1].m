function symbols = qpsk_mod(bits)
%QPSK_MOD Convert binary data into QPSK symbols.
% Mapping:
% 00 -> +1 + j
% 01 -> -1 + j
% 11 -> -1 - j
% 10 -> +1 - j

bits = bits(:);

if mod(length(bits),2) ~= 0
    error('Number of bits must be even for QPSK.');
end

b = reshape(bits,2,[]).';

I = 1 - 2*b(:,2);
Q = 1 - 2*b(:,1);

symbols = (I + 1j*Q)/sqrt(2);
end
