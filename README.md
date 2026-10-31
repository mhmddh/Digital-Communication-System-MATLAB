# Digital Communication System Simulation using MATLAB

<img width="952" height="652" alt="image" src="https://github.com/user-attachments/assets/b951ec93-f2e3-43a6-bad7-bd077588b2c0" />

**Digital Modulation | PAM & QAM | AWGN Channel | BER Analysis | Pulse Shaping**

## Overview

This project implements and analyzes a digital communication system using MATLAB. It investigates the performance of different digital modulation techniques, including Pulse Amplitude Modulation (PAM) and Quadrature Amplitude Modulation (QAM), under Additive White Gaussian Noise (AWGN).

The system simulates the transmission and reception of digital information, from symbol generation and modulation to channel transmission, demodulation, and signal recovery.

The project also evaluates the impact of pulse-shaping filters on transmission performance, comparing Hamming and Square Root Raised Cosine (SRRC) filters.

## Objectives

- Simulate an end-to-end digital communication system.
- Transmit and recover text messages through an AWGN channel.
- Implement different PAM and QAM modulation schemes.
- Evaluate Bit Error Rate (BER) and Symbol Error Rate (SER).
- Analyze BER performance as a function of Eb/N0.
- Compare Hamming and SRRC pulse-shaping filters.
- Investigate the trade-off between noise resistance, bandwidth, and modulation complexity.

## System Architecture

The simulated communication chain consists of the following stages:

**Transmitter**

`Data Generation → Symbol Mapping → Upsampling → Pulse Shaping → Carrier Modulation`

**Channel**

`AWGN Channel`

**Receiver**

`Carrier Demodulation → Low-Pass Filtering → Matched Filtering → Sampling → Symbol Detection → Data Recovery`

The transmitter converts digital information into modulated signals, which are transmitted through a noisy channel. The receiver processes the received waveform and attempts to reconstruct the original information.

## Implementation

### 1. Text Transmission over an AWGN Channel

**File:** `projectA.m`

A text message is encoded into 4-PAM symbols and transmitted through an AWGN channel.

Different noise standard deviations are tested to evaluate the reliability of message recovery.

Experimental observations:

| Noise Standard Deviation (σ) | Observation |
|---|---|
| 0.2 | Message recovered without bit errors |
| 0.3 | Message recovered without bit errors |
| 0.5 | Message recovered without bit errors |
| Approximately 2.0 | BER approximately 3%, SER approximately 4% |

These experiments illustrate how increasing channel noise can degrade the reliability of digital communication.

### 2. PAM and QAM Modulation Comparison

**Files:** `projectB.m`, `projectB3.m`

The system is extended to transmit randomly generated symbol sequences and evaluate different modulation orders.

**PAM Modulation**
- 2-PAM
- 4-PAM
- 16-PAM

**QAM Modulation**
- 4-QAM
- 8-QAM
- 16-QAM

The performance of each modulation scheme is evaluated using the Bit Error Rate (BER) at different signal-to-noise ratios.

The noise level is controlled through the energy-per-bit-to-noise-density ratio (Eb/N0).

### 3. BER vs. Eb/N0 Analysis

Monte Carlo simulations are used to investigate the relationship between communication reliability and channel noise.

The Bit Error Rate is defined as:

**BER = Number of Incorrectly Detected Bits / Total Number of Transmitted Bits**

The Symbol Error Rate is defined as:

**SER = Number of Incorrectly Detected Symbols / Total Number of Transmitted Symbols**

The simulation results presented in the project show that:

- BER generally decreases as Eb/N0 increases.
- Higher-order modulation schemes introduce different noise sensitivity and spectral-efficiency trade-offs.
- QAM demonstrated better BER performance than PAM in the reported experimental comparison.
- At Eb/N0 = 12 dB, the presented results reported BER values near 10⁻⁸ for QAM and 10⁻⁴ for PAM.

These results illustrate the importance of selecting an appropriate modulation technique according to channel conditions and system requirements.

### 4. Pulse-Shaping Filter Comparison

**Files:** `projectCpam.m`, `projectCqam.m`

The project investigates the influence of pulse-shaping filters on digital communication performance.

Two filtering approaches are studied:

**Hamming Filter**
- Used as the initial pulse-shaping approach.
- Provides a baseline for comparing transmission performance.

**Square Root Raised Cosine (SRRC) Filter**
- Used for pulse shaping and receiver filtering.
- Designed to control intersymbol interference (ISI).
- Supports bandwidth control through the roll-off factor β.

The experiments investigate SRRC filtering with roll-off factors including:

- β = 0.5
- β = 1.0

The presented results show improved error performance for the tested SRRC configurations compared with the Hamming-based implementation.

Increasing the roll-off factor also increases the occupied bandwidth, illustrating the trade-off between bandwidth efficiency and pulse-shaping characteristics.

## Project Structure

```text
Digital-Communication-System-MATLAB/
│
├── projectA.m          # Text transmission through AWGN
├── projectB.m          # PAM modulation and BER analysis
├── projectB3.m         # QAM modulation and BER analysis
├── projectCpam.m       # PAM with SRRC pulse shaping
├── projectCqam.m       # QAM with SRRC pulse shaping
│
└── README.md
```

## Technologies and Concepts

**Programming and Simulation**
- MATLAB
- Monte Carlo Simulation
- Digital Signal Processing

**Digital Communications**
- Pulse Amplitude Modulation (PAM)
- Quadrature Amplitude Modulation (QAM)
- Additive White Gaussian Noise (AWGN)
- Bit Error Rate (BER)
- Symbol Error Rate (SER)
- Signal-to-Noise Ratio (Eb/N0)
- Pulse Shaping
- Matched Filtering
- Intersymbol Interference (ISI)

## How to Run

1. Download or clone the repository.
2. Open MATLAB.
3. Add the project directory to the MATLAB path.
4. Run the desired simulation script.

For example:

```matlab
run('projectA.m')
```

To test PAM modulation:

```matlab
run('projectB.m')
```

To test QAM modulation:

```matlab
run('projectB3.m')
```

To investigate SRRC pulse shaping:

```matlab
run('projectCpam.m')
run('projectCqam.m')
```

The scripts prompt for relevant simulation parameters, such as modulation order, noise standard deviation, or Eb/N0.

**Note:** The original scripts use helper functions from the MATLAB digital communications examples, including functions such as `letters2pam`, `plotspec`, and `srrc`. These dependencies must be available on the MATLAB path. Some scripts also require Signal Processing Toolbox functionality.

## Key Takeaways

This project provides practical experience in:

- Designing and simulating digital communication chains.
- Understanding the effect of AWGN on signal recovery.
- Comparing digital modulation techniques.
- Evaluating communication reliability through BER and SER.
- Analyzing the relationship between signal quality and transmission performance.
- Investigating pulse shaping and intersymbol interference.

## Academic Context

Developed as part of the **EENG537 – Digital Communications** course at Lebanese International University (LIU), Department of Computer and Communication Engineering, during the 2019–2020 academic year.


## Author

**Mohammad Daher**

Telecommunications Engineer | Wireless Communications | Signal Processing

GitHub: https://github.com/mhmddh
