% OFDM MODULATION OVER TWO ANTENNAS
% 2x2 MIMO-OFDM using QPSK, Rayleigh fading and AWGN
% College Digital Communication Project
%
% Run this file from MATLAB.

clear; clc; close all;
rng(10);                         % Repeatable results

%% Parameters
Nfft        = 64;               % Number of OFDM subcarriers
cpLen       = 16;               % Cyclic prefix length
numSymbols  = 1000;             % OFDM symbols
M           = 4;                % QPSK
bitsPerSym  = log2(M);
snrDb       = 0:2:20;           % SNR range
numTx       = 2;
numRx       = 2;

fprintf('2x2 MIMO-OFDM Simulation\n');
fprintf('Subcarriers: %d | CP: %d | OFDM symbols: %d\n', ...
    Nfft, cpLen, numSymbols);

%% Generate random bits for each transmit antenna
numBits = Nfft * numSymbols * bitsPerSym;
txBits = randi([0 1], numBits, numTx);

% QPSK modulation
txQpsk = zeros(Nfft*numSymbols, numTx);
for tx = 1:numTx
    txQpsk(:,tx) = qpsk_mod(txBits(:,tx));
end

%% OFDM modulation
txWave = zeros((Nfft+cpLen)*numSymbols, numTx);

for tx = 1:numTx
    freqData = reshape(txQpsk(:,tx), Nfft, numSymbols);
    timeData = ifft(freqData, Nfft, 1) * sqrt(Nfft);

    % Add cyclic prefix
    withCP = [timeData(end-cpLen+1:end,:); timeData];

    txWave(:,tx) = withCP(:);
end

%% Plot one OFDM waveform
figure('Name','OFDM Transmitted Waveforms');
plot(real(txWave(:,1)));
hold on;
plot(real(txWave(:,2)));
grid on;
xlabel('Sample');
ylabel('Amplitude');
title('Real Part of OFDM Signals from Two Transmit Antennas');
legend('Tx Antenna 1','Tx Antenna 2');

%% 2x2 MIMO channel
% One independent flat-fading complex coefficient for every link.
H = (randn(numRx,numTx) + 1j*randn(numRx,numTx))/sqrt(2);

disp('2x2 MIMO Channel Matrix H = ');
disp(H);

%% Simulation over SNR
ber = zeros(size(snrDb));

for s = 1:length(snrDb)
    % Received signals: Y = X*H^T + noise
    rxClean = txWave * H.';

    signalPower = mean(abs(rxClean(:)).^2);
    noisePower = signalPower / (10^(snrDb(s)/10));
    noise = sqrt(noisePower/2) * ...
        (randn(size(rxClean)) + 1j*randn(size(rxClean)));

    rxWave = rxClean + noise;

    %% Remove CP and FFT
    rxNoCP = zeros(Nfft*numSymbols, numRx);

    for rx = 1:numRx
        temp = reshape(rxWave(:,rx), Nfft+cpLen, numSymbols);
        temp = temp(cpLen+1:end,:);
        freqRx = fft(temp, Nfft, 1) / sqrt(Nfft);
        rxNoCP(:,rx) = freqRx(:);
    end

    %% ZF MIMO equalization
    rxDetected = zeros(Nfft*numSymbols, numTx);

    W = pinv(H);                 % Zero-Forcing equalizer

    for k = 1:Nfft*numSymbols
        y = rxNoCP(k,:).';
        xHat = W*y;
        rxDetected(k,:) = xHat.';
    end

    %% QPSK demodulation and BER
    totalErrors = 0;

    for tx = 1:numTx
        detectedBits = qpsk_demod(rxDetected(:,tx));
        totalErrors = totalErrors + sum(detectedBits ~= txBits(:,tx));
    end

    ber(s) = totalErrors / (numBits*numTx);

    fprintf('SNR = %2d dB, BER = %.6g\n', snrDb(s), ber(s));
end

%% BER plot
figure('Name','BER Performance');
semilogy(snrDb, ber, 'o-','LineWidth',1.5);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance of 2x2 MIMO-OFDM');
legend('2x2 MIMO-OFDM','Location','southwest');

%% QPSK constellation at a representative SNR
selectedSnr = 10;
s = find(snrDb == selectedSnr,1);

if isempty(s)
    s = ceil(length(snrDb)/2);
end

% Re-run one selected SNR for constellation visualization
rxClean = txWave * H.';
signalPower = mean(abs(rxClean(:)).^2);
noisePower = signalPower / (10^(snrDb(s)/10));
noise = sqrt(noisePower/2) * ...
    (randn(size(rxClean)) + 1j*randn(size(rxClean)));
rxWave = rxClean + noise;

rxNoCP = zeros(Nfft*numSymbols,numRx);
for rx = 1:numRx
    temp = reshape(rxWave(:,rx),Nfft+cpLen,numSymbols);
    temp = temp(cpLen+1:end,:);
    freqRx = fft(temp,Nfft,1)/sqrt(Nfft);
    rxNoCP(:,rx) = freqRx(:);
end

rxDetected = zeros(Nfft*numSymbols,numTx);
W = pinv(H);
for k = 1:Nfft*numSymbols
    rxDetected(k,:) = (W*rxNoCP(k,:).').';
end

figure('Name','QPSK Constellation');
plot(real(rxDetected(:,1)), imag(rxDetected(:,1)), '.');
grid on;
xlabel('In-Phase');
ylabel('Quadrature');
title(sprintf('Detected QPSK Constellation - Tx Antenna 1 at %d dB',snrDb(s)));
axis equal;

fprintf('\nSimulation completed successfully.\n');
