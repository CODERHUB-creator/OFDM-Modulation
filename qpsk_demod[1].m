function bits = qpsk_demod(symbols)
%QPSK_DEMOD Convert QPSK symbols back into binary data.

symbols = symbols(:);

b1 = imag(symbols) < 0;
b2 = real(symbols) < 0;

bits = zeros(2*length(symbols),1);
bits(1:2:end) = b1;
bits(2:2:end) = b2;
end
