clear;
close all;
clc;

P = 2; %Períodos dos sinal
A = 1; %Amplitude do sinal
fund_freq = 60; %Frequência fundamental do sinal

%Vetor de frequências de amostragem
sample_freqs = [480 960 1920 3840];

%Calcula o tempo total de amostragem do sinal
total_time = 1/fund_freq * P;

%Percorre todas as frequências de amostragem definidas no vetor
for i = 1:length(sample_freqs)
    sf = sample_freqs(i);

    %Vetor que contém as timestamps
    %Formato vetor = inicio:passo:fim ou inicio:fim com passo 1
    %Neste caso, o vetor começa em zero e vai até o último timestamp, com
    %passo 1, logo, dividimos o passo por sf pra ter o timestamp discreto em
    %segundos
    disc_t = (0:(total_time * sf) - 1) / sf;

    %Sinal discretizado
    sinal = A * sin (2 * pi * fund_freq * disc_t);

    %Plota os gráficos um abaixo do outro, para cada frequência de
    %amostragem
    figure(i)
    plot(disc_t,sinal,'lineWidth',2);
    xlabel('Tempo');
    ylabel('Amplitude');
    title(sprintf('FS = %d Hz',sf))
    grid on;
end