# OFDM Modulation Over Two Antennas

## Project
Digital Communication - 2x2 MIMO-OFDM Simulation in MATLAB

## Objective
To simulate an OFDM communication system using two transmit antennas and two receive antennas, and study its BER performance under Rayleigh fading and AWGN noise.

## Main Features
- QPSK modulation
- 64 OFDM subcarriers
- 16-sample cyclic prefix
- 2 transmit antennas
- 2 receive antennas
- 2x2 MIMO channel
- Rayleigh flat fading
- AWGN noise
- Zero-Forcing (ZF) MIMO equalization
- BER versus SNR graph
- QPSK constellation
- Transmitted OFDM waveform plot

## Files

### main_OFDM_2x2.m
Main simulation program. Run this file.

### qpsk_mod.m
Converts binary bits into QPSK complex symbols.

### qpsk_demod.m
Converts received QPSK symbols back into binary bits.

## Requirements
MATLAB R2019b or newer is recommended. The project uses basic MATLAB functions and does not require a special toolbox.

## How to Run
1. Extract the ZIP file.
2. Open MATLAB.
3. Set the extracted folder as the Current Folder.
4. Open `main_OFDM_2x2.m`.
5. Click Run.

## System Flow

Random Bits
   ↓
QPSK Modulation
   ↓
OFDM Mapping
   ↓
IFFT
   ↓
Cyclic Prefix
   ↓
Two Transmit Antennas
   ↓
2x2 Rayleigh MIMO Channel + AWGN
   ↓
Remove Cyclic Prefix
   ↓
FFT
   ↓
ZF MIMO Equalization
   ↓
QPSK Demodulation
   ↓
BER Calculation

## Important Note
This is a simulation model for academic demonstration. The channel is modeled as a flat-fading 2x2 MIMO channel. For a more advanced project, the model can be extended to frequency-selective multipath channels, pilot-based channel estimation, Alamouti/STBC, MMSE detection, higher-order QAM, and PAPR analysis.
