import numpy as np
import matplotlib.pyplot as plot

fund_f = 60                         # 60 Hz de frequência fundamental

sample_freqs = [480,960,1920,3840]  # Frequências de amostragem

amp = 1                             # Amplitude do sinal

n_cycles = 2                        # Número de períodos a serem amostrados

for fs in sample_freqs:
        
        # Tempo discretizado para cada amostra
        # Cria um vetor com cada ponto no tempo
        # Amostra a cada 1/fs segundos (inverso da frequência de amostragem)
        disc_t = np.arange(0,n_cycles * 1/fund_f, 1/fs)

        # Gera o sinal senoidal com as frequências desejadas
        signal = amp * np.sin(2 * np.pi * fund_f * disc_t)

        # Plota o sinal
        plot.figure()
        plot.stem(disc_t,signal,use_line_collection=True)
        plot.title(f"Senoide Discreta 60 Hz - Freq. de Amostragem: {fs} Hz.")
        plot.xlabel("Tempos (s)")
        plot.ylabel("Amplitude")
        plot.grid(True)

        # Salva as imagens no drietório do script
        plot.savefig(f"Senoide Discreta 60 Hz - Freq. de Amostragem: {fs} Hz.png")

plot.show() # Exibe os gráficos na tela