import matplotlib.pyplot as mp
import numpy as np

def dft(signal: list[float]) -> np.ndarray:
    len = signal.__len__()

    X = np.zeros(len,complex)

    for m in range(len):

        for n in range(len):

            X[m] += signal[n] * np.exp(-1j * 2 * np.pi * n * m / len)
    
    return X
            
            
# Abre os arquivos de amplitude do sinal e do tempo discreto no modo leitura
sinal_file = open("Sinal.txt","r")
time_file = open("TimeStamp.txt","r")

# Lê tudo e separa pelo delimitador ';' -> Transforma em uma lista de strings
val_list = sinal_file.read().split(';')
time_list = time_file.read().split(';')

# Converte de str para float cada elemento da lista
val_list = [float(x) for x in val_list]
time_list = [float(x) for x in time_list]

# Número total de amostras
smpl_numb = val_list.__len__()

smpl_freq = 0.0
total_time = 0

# Percorre até o penúltimo elemento do vetor de timestamp
for i in range(0,smpl_numb - 1):

    # Soma todos os períodos entre amostragens
    total_time += time_list[i+1] - time_list[i]

# Dívide operíodo total de coleta pelo n° de amostras (Tamanho médio de cada período, descontando a primeira amostragem)
total_time = total_time/float(smpl_numb - 1)
    
# Frequência de amostragem == 1/período médio
smpl_freq = 1/(total_time)

print(f"Frequência de amostragem: {smpl_freq:0.2f} Hz")

# Aplica a dft
X = dft(val_list)

# Cria um vetor com tamanho do número de amostras cujo espaçamento entre passos é a frequência de amostragem/número de amostras
freqs = np.arange(smpl_numb) * smpl_freq / smpl_numb

# Pega apenas o semiciclo positivo do sinal
half = smpl_numb//2
pstv_half = X[:half]


freqs_half = freqs[:half]

# Pega apenas as frequências positivas
amplitudes = (2/smpl_numb) * np.abs(pstv_half)

# Define o treshold como 1% da amplitude mais alta
treshold =  float(0.01 * np.max(amplitudes))

# Pega os índices onde as amplitudes são maiores que os tresholds (frequências harmônicas)
harmonic_idx = np.where(amplitudes >= treshold)[0]

# Exclui o nível DC da análise e guarda apenas as frequências harmônicas
harmonic_freq = freqs_half[harmonic_idx]

# Respectivas amplitudes das frequências harmônicas
harm_amps = amplitudes[harmonic_idx]

# Pega o índice da frequência fundamental (menor valor dentre os harmônicos)
fund_idx = np.where(np.min(harmonic_idx) == harmonic_idx)[0]

# Frequência fundamental
fund_freq = float(harmonic_freq[fund_idx])

print("Harmônicos: ")
count = 0
for hf in harmonic_freq:
    print(f"\t{int(hf/fund_freq)}° Harmônico = {hf:.2f}, Amplitude: {harm_amps[count]:.2f}")
    count += 1

print(f"\n")

print(f"Freq. fundamental: {fund_freq:.2f}\n")

# Amplitude da freq. fundamental
fund_amp = float(amplitudes[int(fund_freq)])
print(f"Amplitude da freq. fundamental: {fund_amp:.2f}\n")



