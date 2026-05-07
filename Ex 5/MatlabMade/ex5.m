clear;
close all;
clc;


% Lendo a imagem original
img = imread('./Ex 5/imagem.jpg');

% Filtrando cada canal - Imagem vem em matriz de 3 dimensões, sendo [X,X,1] = R; [X,X,2] = G; [X,X,3] = B;

% Red
R_img = img;
R_img(:,:,2) = 0;
R_img(:,:,3) = 0;

% Green
G_img = img;
G_img(:,:,1) = 0;
G_img(:,:,3) = 0;

% Blue
B_img = img;
B_img(:,:,2) = 0;
B_img(:,:,1) = 0;

% Exibe a imagem original e a de cada canal
figure(1)
subplot(2,2,1)
imshow(img);
title('Imagem original')

subplot(2,2,2)
imshow(R_img);
title("R");

subplot(2,2,3)
imshow(G_img);
title("G");

subplot(2,2,4)
imshow(B_img);
title("B");

% Transformando em grayscale:
R = im2double(img(:,:,1)); 
G = im2double(img(:,:,2));
B = im2double(img(:,:,3));

F_R = fft2(R);
F_G = fft2(G);
F_B = fft2(B);

F_R = fftshift(F_R);
F_G = fftshift(F_G);
F_B = fftshift(F_B);

% Aplicando mascáras
high_mask = im2double(rgb2gray(imread('./Ex 5/altafreq_mask.jpg')));
low_mask = im2double(rgb2gray(imread('./Ex 5/baixafreq_mask.jpg')));

% Não precisa aplicar fft2 pois já estão em escalas de cinza, nem fftshift pois as mascaras ja estão de acordo como sentido (altas frequências no meio) e baixas freqs na borda


% Alta frequência
hF_R = F_R .* high_mask;
hF_G = F_G .* high_mask;
hF_B = F_B .* high_mask;

hr = ifft2(ifftshift(hF_R));
hg = ifft2(ifftshift(hF_G));
hb = ifft2(ifftshift(hF_B));

hrecon = zeros(size(img));
hrecon(:,:,1) = real(hr);
hrecon(:,:,2) = real(hg);
hrecon(:,:,3) = real(hb);

figure(2)
imshow(hrecon,[]);
title('Filtro "passa-alta"');
% -------------------------
% Baixa frequência
lF_R = F_R .* low_mask;
lF_G = F_G .* low_mask;
lF_B = F_B .* low_mask;

lr = ifft2(ifftshift(lF_R));
lg = ifft2(ifftshift(lF_G));
lb = ifft2(ifftshift(lF_B));

lrecon = zeros(size(img));
lrecon(:,:,1) = real(lr);
lrecon(:,:,2) = real(lg);
lrecon(:,:,3) = real(lb);

figure(3)
imshow(lrecon,[]);
title('Filtro "passa-baixa"');
% ---------------------------

% Compressão do arquivo de áudio.

% Lê o arquivo de aúdio
[audio,fs] = audioread('./Ex 5/musica.wav');

% Transforma o áudio de stereo para mono
if size(audio,2) == 2
    audio = mean(audio,2);
end

% Tamanho do sinal
len = length(audio);

% Aplica a FFT
Audio = fft(audio);

% Variáveis auxiliares de percentual de pontos mantidos
percf = 0.05;   % 5%
perct = 0.01;   % 1%

% Valor igual à 5% dos pontos do sinal de áudio
k = round(percf * len);

% Ordena pela amplitude, de maneira decrescente, e retorna os índices correspondentes no sinal original/fft
[~,idxs] = sort(abs(Audio),'descend');

% Cria um vetor inicializado em 0, com mesmo tamanho do sinal original
Af_comp = zeros(size(Audio));

% Os índices correspondentes estão ordenados da maior para a menor amplitude. Como queremos manter os k índices de maior amplitude, percorremos o vetor de índices ordenado de 1 até k
Af_comp(idxs(1:k)) = Audio(idxs(1:k));

% Aplicamos a ifft
af_comp = ifft(Af_comp);

% Garantimos que seja um sinal real
af_comp = real(af_comp);

% Repete o processo, agora mantendo apenas 2% das maiores amplitudes
k = round(perct * len);

Ao_comp = zeros(size(Audio));
Ao_comp(idxs(1:k)) = Audio(idxs(1:k));

ao_comp = ifft(Ao_comp);
ao_comp = real(ao_comp);

% Vetor de tempo discretizado
t = (0:len-1)/fs;

% Plota os sinais
figure(3)
subplot(3,1,1)
plot(t,audio);
title('Áudio original');

subplot(3,1,2)
plot(t,af_comp);
title('Áudio comprimido - 5% mantido');

subplot(3,1,3)
plot(t,ao_comp);
title('Áudio comprimido - 1% mantido');
% ----------------------------------------

% Salva os novos arquivos de aúdio comprimidos
audiowrite('./Ex 5/musica5.wav',af_comp,fs);
audiowrite('./Ex 5/musica1.wav',ao_comp,fs);