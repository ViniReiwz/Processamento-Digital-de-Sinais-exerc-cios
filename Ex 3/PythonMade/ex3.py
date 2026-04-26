# SEL0615 – PROCESSAMENTO DIGITAL DE SINAIS
# Nome: Vinicius Reis Gonçalves
# Nº USP: 15491921

import numpy as np
import matplotlib.pyplot as plt

# -------------------------
# Signal definition
# -------------------------
def signal(t):
    S = 1*np.sin(2*np.pi*t*50)
    S += 0.5*np.sin(2*np.pi*t*300)
    S += 0.25*np.sin(2*np.pi*t*500)
    return S

# Sampling parameters
sample_freq = 50 * 128
sample_period = 1 / sample_freq
sample_time = 0.11

time_vec = np.arange(0, sample_time + sample_period, sample_period)
signal_vec = signal(time_vec)
signal_len = len(signal_vec)

# Plot original signal
plt.figure()
plt.plot(time_vec, signal_vec, 'r')
plt.title('Sinal original')
plt.xlabel('Tempo (s)')
plt.ylabel('Amplitude')
plt.grid()
plt.show()

# -------------------------
# DFT implementation
# -------------------------
def dft(x):
    N = len(x)
    X = np.zeros(N, dtype=complex)
    for m in range(N):
        freq_comp = 0
        for n in range(N):
            freq_comp += x[n] * (np.cos(2*np.pi*n*m/N) - 1j*np.sin(2*np.pi*n*m/N))
        X[m] = freq_comp
    return X

def normalize_dft(signal_f_vec, sample_freq, signal_len, G):
    half = signal_len // 2
    freqs_vec = np.arange(signal_len) * (sample_freq / signal_len)
    freqs_vec = freqs_vec[:half+1]

    mags_vec = np.abs(signal_f_vec) / (signal_len * G)
    mags_vec = mags_vec[:half+1]
    mags_vec[1:-1] = 2 * mags_vec[1:-1]

    return freqs_vec, mags_vec

def plot_dft(name, freqs_vec, mags_vec):
    plt.figure()
    plt.stem(freqs_vec, mags_vec)
    plt.title(f'Espectro do Sinal {name}')
    plt.xlabel('Frequência (Hz)')
    plt.ylabel('Amplitude')
    plt.xlim([0, 1000])
    plt.grid()
    plt.show()

# Original DFT
signal_f_vec = dft(signal_vec)
freqs_vec, mags_vec = normalize_dft(signal_f_vec, sample_freq, signal_len, 1)
plot_dft('Original', freqs_vec, mags_vec)

# -------------------------
# Energy calculation
# -------------------------
def signal_energy(sample_freq, signal_len, signal_f_vec):
    total_energy = 0
    for i in range(signal_len):
        f = i * sample_freq / signal_len

        if (0 <= f <= 1000) or (sample_freq - 1000 <= f <= sample_freq):
            total_energy += abs(signal_f_vec[i])**2

    return total_energy / signal_len

total_energy = signal_energy(sample_freq, signal_len, signal_f_vec)
print(f"Energia do sinal (0-1kHz): {total_energy}")

# -------------------------
# Window functions
# -------------------------
windows = {
    "Hann": np.hanning(signal_len),
    "Hamming": np.hamming(signal_len),
    "Retangular": np.ones(signal_len),
    "Blackman": np.blackman(signal_len)
}

for name, w in windows.items():
    signal_f_vec = dft(signal_vec * w)
    freqs_vec, mags_vec = normalize_dft(signal_f_vec, sample_freq, signal_len, np.mean(w))
    plot_dft(name, freqs_vec, mags_vec)

    total_energy = signal_energy(sample_freq, signal_len, signal_f_vec)
    print(f"Energia com janela {name}: {total_energy}")
