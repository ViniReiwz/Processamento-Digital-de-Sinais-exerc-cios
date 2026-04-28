clear;
close all;
clc;

% -------------------------------------------------------------------------------------
% DFT
function X = dft(x)
    len = length(x);
    X = 0:len-1;
    for m = 0:len-1
        soma = 0;
        for n = 0:len-1
            soma = soma + x(n+1) * exp(-1j*2*pi*n*m/len);
        end
        X(m+1) = soma;
    end
end

% Calcula a energia de um sinal em uma faiza de 0 Hz até max_freq Hz
function Energy = sig_energy(freqs_vec, dft_sinal, max_freq)
    N = length(dft_sinal);
    [~,k_max] = min(abs(freqs_vec - max_freq));
    Energy = sum(abs(dft_sinal(1:k_max)).^2) / N; 
end

% -------------------------------------------------------------------------------------

fund_freq = 50; % Frequência fundamental de 50 Hz


sample_freq = fund_freq * 128;  % Dessa forma, haverão 128 medições por ciclo

% Tempo de amostragem
sampling_time = 0.11;

% Número de amostras coletadas
sample_numb = round(sampling_time * sample_freq);

% Vetor de tempo discreto (timestamp)
t = (0:sample_numb-1)/sample_freq;

% Gerando os sinais
s1 = 1 * sin(2*pi*fund_freq*t); % 50 Hz
s6 = 0.5 * sin(2*pi*300*t);     % 300 Hz
s10 = 0.25 * sin(2*pi*500*t);   % 500 Hz

sinalf = s1 + s6 + s10; % Soma todos os sinais em um único

% Metade das amostras
halfN = floor(sample_numb/2);

% Espectro de frequências
freqs_vec = 0:sample_freq/sample_numb:sample_freq;

% Aplica a DFT no sinal sem janelamento
dft_sinal = dft(sinalf);

% Pega pela metade (Sinal real)
dft_sinal = dft_sinal(1:halfN);
freqs_vec = freqs_vec(1:halfN);

% Calcula da energia do sinal na faiza de 0 Hz à 1 KHz
energy = sig_energy(freqs_vec,dft_sinal,1000);

% Aplicando os janelamentos
hann_s = sinalf .* hann(sample_numb)';
hamming_s = sinalf .* hamming(sample_numb)';
blackman_s = sinalf .* blackman(sample_numb)';

% DFTs dos sinais janelados
hann_dft = dft(hann_s);
hamming_dft = dft(hamming_s);
blackman_dft = dft(blackman_s);

% Pegando apenas meio sinal (sinal real)
hann_dft = hann_dft(1:halfN);
hamming_dft = hamming_dft(1:halfN);
blackman_dft = blackman_dft(1:halfN);

% Plotando os gráficos
figure

subplot(2,2,1)
plot(freqs_vec, abs(dft_sinal))
title('Sem janela')

subplot(2,2,2)
plot(freqs_vec, abs(hann_dft))
title('Hann')

subplot(2,2,3)
plot(freqs_vec, abs(hamming_dft))
title('Hamming')

subplot(2,2,4)
plot(freqs_vec, abs(blackman_dft))
title('Blackman')

% Sem janelamento
disp(energy);

% Calculando energia dos outros sinais
disp(sig_energy(freqs_vec,hann_dft,1000));
disp(sig_energy(freqs_vec,hamming_dft,1000));
disp(sig_energy(freqs_vec,blackman_dft,1000));

% Observa-se que ao aplciar o janelamento, fica mais evidente o intervalo em que se concentra a energia do sinal, diminuindo assim o leakage. Mas em contrapartida, por limitar o intervalo do sinal, a energia do mesmo cai drasticamente. Aplicar o janelamento tem vantagem de reduzir o leakage mas também acarreta na perda de energia do sinal, bem como na perca de resoluçao do espectro de frequências