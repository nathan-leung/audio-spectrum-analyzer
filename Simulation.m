close all
clear all
clc

% Simulation
% Run and wait. Audio Will play automatically and graphically display the
% bands.

[wav, Fs] = audioread('audio_file.wav');

rng default

t= linspace(0,size(wav,1)/Fs,size(wav,1));

% thresholds = [20 25 31 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1200 1600 2000 2500 3200 4000 5000 6300 8000 10000 12000 16000 20000];
thresholds = [35 72 150 325 575 1025 2150 4420 9300 20000];
output = NaN(10, size(wav,1));

%Build the new audio files for each of the bands
for ii = 1:size(thresholds,2)
    freq = thresholds(ii);    
    tau= 1/(freq*2*pi);

    num = [tau 0];
    denom = [(tau*tau) (tau+tau)  1];
    H = tf(num,denom);
    output(ii,:) = lsim(H,wav,t);
end




max_arr = NaN(1,size(thresholds,2));
hold off
figure

% Output now has 10 bands for the entire song
player = audioplayer(wav, Fs);
play(player);

start = tic();
% Iterate through the file 0.05s at a time
for k=1:2205:size(wav,1)
    
    
    for jj = 1:size(thresholds,2)
        max_arr(jj) = rms(output(jj, k:1:k+2204));
    end
    
    bar(max_arr)
    axis([0 size(thresholds,2)+1 0 0.3]);
    title(['Current Time: ', num2str(floor(k/Fs)), 's']);
    xlabel('Band Number');
    ylabel('Relative Amplitude');
    drawnow
    
    elapsed = toc(start);
    pause((0.05-elapsed)*0.75);
    start = tic();
end

