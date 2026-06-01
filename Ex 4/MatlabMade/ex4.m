clear;
close all;
clc;

% Abordagem recursiva da FFT
function X = fft(x,W)

    N = length(x);

    % Condição de parada (Vetor com apenas um único elemento [n-ésima rais da unicidade])
    if N == 1 %#ok<ISCL>
        X = x;
        return;
    end

    % Garante que vai ser potência de 2
    assert(N > 0 && bitand(N,N-1) == 0);

    % Divide o sinal entre par e ímpar
    x_par = x(1:2:end);     % Indíce 1 no matlab == indíce 0
    x_impar = x(2:2:end);   % Indíce 2 no matlab == indíce 1

    % Gera uma partição dos coeficientes twiddles, dado a propriedade que W_N[2k] == W_(N/2)[k]
    W_sub = W(1:2:end);

    % Aplica a FFT para o sinal repartido, na parte par e ímpar, recursivamente
    X_par = fft(x_par,W_sub);
    X_impar = fft(x_impar,W_sub);

    % Cria um vetor de tamanho N
    X = zeros(1,N);

    % Remonta o espectro de frequÇencias a partir daparte par e ímpar.
    X(1:N/2) = X_par + W(1:N/2) .* X_impar;
    X((N/2)+1:N) = X_par - W(1:N/2) .* X_impar;
end

% FFT radix2
function X = fft_radix2(x)
    
    % Tamanho do sinal
    N = length(x);
    % Índices dos twiddles possíveis
    k = (0:(N/2) - 1);
    % Cria o vetor com todos os twiddles possíveis
    W = exp(-1j*2*pi*k/N);  

    % Aplica a FFT recursivamente
    X = fft(x,W);
end

function x = ifft_my(X)
    
    % Tamanho do sinal
    N = length(x);
    % Índices dos twiddles possíveis
    k = (0:(N/2) - 1);
    % Cria o vetor com todos os twiddles possíveis
    W = exp(-1j*2*pi*k/N);  

    x = conj(fft(conj(X),W));
end


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

% Frequência fundamental de 50 Hz
fund_freq = 50;

% Pega 8 ciclos completos do sinal
n_cycles = 8;

% Como deve ter 2048 amostras por ciclos, multiplicamos a frequência funndamental por 2048
sample_freq = fund_freq * 2048;

% Cálculo do número de amostras
sample_numb = (n_cycles/fund_freq) * sample_freq;

% Discretização do tempo
t = (0:sample_numb-1)/sample_freq;

% Cria o sinaç
signal = 1 * sin(2*pi*t*fund_freq);

% Aplica a fft_radix2
fft_signal = fft_radix2(signal);

% Pega apenas o módulo das amplitudes para cada frequência
fft_signal = abs(fft_signal);

% Cria o vetor de frequências
freqs_vec = (0:sample_numb-1) * (sample_freq/sample_numb);

% Como o sinal é real, corta a frequência e o sinal pela metade (simetria)
fft_signal = fft_signal(1:floor(sample_numb/2));
freqs_vec = freqs_vec(1:floor(sample_numb/2));

% Plota tudo
figure(1)
plot(t,signal,'r','LineWidth',2);
figure(2)
plot(freqs_vec,fft_signal,'r','LineWidth',2);

% Vetor que armazena os tempos de execução da fft
tempo_fft = zeros(1,30);

% Executa a fft 30 vezes
for k = 1:30
    tic
    trash_sig1 = fft_radix2(signal);
    % Guarda tempo de execução da k-ésima vez
    tempo_fft(k) = toc;
end

% Faz a mesma coisa para a DFT
tempo_dft = zeros(1,30);

for k = 1:30
    tic
    trash_sig2 = dft(signal);
    tempo_dft(k) = toc;
end

% Plota os tempos
figure(3)
plot(1:30,tempo_fft,'b','LineWidth',2);
figure(4)
plot(1:30,tempo_dft,'b','LineWidth',2);

grid on;
