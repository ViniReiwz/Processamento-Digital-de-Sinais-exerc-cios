clear;
close all;
clc;

% Definição da função da dft (Discrete Fourier Transform)
% Recebe um sinal no tempo como entrada e retorna outro na frequência
function X = dft(x)

    % Tamanho do sinal (n° de amostras)
    len = length(x);

    % Cria o vetor do sinal resultante, com o mesmo número de elementos
    X = 0:len-1;

    % Cada ínidice m representa um espectro de frequências
    for m = 0:len-1
        soma = 0;

        % Cada ínidice m representa uma amostra no tempo
        for n = 0:len-1

            % Dessa forma, efetua o somatório para todas as amostras no tempo
            % E portanto, gera para cada índice 'm', a associação de amplitude de uma senoide de frequência (m/len) * freq_amostragem existe no sinal temporal.
            % Por isso, a transformada de fourier tira o sinal do domínio do tempo e passa ao domínio da frequência, dizendo 'quanto desta frequência, expressa peal fórmula anterior, esta presente neste sinal'.
            soma = soma + x(n+1) * exp(-1j*2*pi*n*m/len);
        end

        % Atribui o valor ao sinal
        X(m+1) = soma;
    end
end

% Lê o arquivo com as amplitudes do sinal
signal = readmatrix('Sinal.txt','Delimiter',';');

% Lê o arquivo de timestamp
timestamp = readmatrix('TimeStamp.txt','Delimiter',';');

% Variável auxiliar que registra o 'tempo total' de medição
total_time = 0;

% N == número de amosstras
sample_numb = length(timestamp);

% Calcula o tempo total de medição
for k = 1:sample_numb - 1
    total_time = total_time + (timestamp(k+1) - timestamp(k));
end

% Calcula a frequência de amostragem
sample_freq = sample_numb/total_time;

% Constrói o vetor de frequências
freqs = 0:sample_freq/sample_numb:sample_freq;

% Aplicando a dft:
dft_signal = dft(signal);

% Variável auxiliar pra cortar pela metade o intervalo
halfN = floor(sample_numb/2);

% Pega apenas a primeira metade do espectro de frequências dado que o sinal é real então
% a segunda metade é redundante
dft_signal = dft_signal(1:halfN);

% Quebra também pela metade para refletir o que foi feito com o sinal anteriormente
freqs = freqs(1:halfN);

% Como a energia é dividida entre as duas metades do sinal, para que a amplitude real seja dada, multiplicamos por um fator de correção 2/N
amplitudes = (2/sample_numb) * abs(dft_signal);

% Define o treshold como sendo 1% da maior amplitude registrada, filtrando assim os harmônicos
treshold = 0.01 * max(amplitudes);

% Pega os harmônicos do sinal, encontrando os ínidices para que a amplitude do sinal seja maior que o threshold
harmonics_idx = amplitudes > treshold;

% Verifica o vetor de frequências e pega os índices encontrados anteriormente
harmonics_freq = freqs(harmonics_idx);

% Faz o mesmo para as amplitudes
harmonics_amps = amplitudes(harmonics_idx);

% Pega o índice do valor máximo das amplitudes dos harmônicos (1°harmônico == frequência fundamental)
[a,ff_idx] = max(harmonics_amps);

% Consulta a frequência fundamental no vetor de frequências
fund_freq = freqs(ff_idx);

% Plota o gráfico
figure(1)
plot(freqs,amplitudes,'b','LineWidth',2);
xlabel('Frequência');
ylabel('Amplitude');
grid on