% Read the signal
[signal, fs] = audioread("Path\to\recording");

% Build array with the target frequency values starting at 50 Hz, up to
% 4000Hz, every third of an octave
start_freq = 50;
end_freq = 4000;
intervals_per_octave = 3;
octave_range = log2(end_freq/start_freq);
total_intervals = octave_range * intervals_per_octave;
freq_values = [50];

for i=1:total_intervals
  freq_value = start_freq * 2^(i/intervals_per_octave);
  freq_values = [freq_values,freq_value];
end

freq_values = [freq_values, 4000];

% Set the parameters for the call to spectrogram()
window_size = round(0.025 * fs);       % 25ms windows
overlap = round(0.015*fs);             % To get a value for every 10 ms an overlap of 15 is needed
[S,f,t] = spectrogram(signal, window_size, overlap, freq_values, fs);

% Build empty matrix for the amplitude values squaring the values
% obtainded from calling spectrogram
signal_length = length(signal)/fs;
m = round(signal_length/0.01);         % number of 10ms windows
n = length(freq_values);               % number of frequencies
amplitudes = abs(S).^2;                % calculate Power Spectral Density
A = zeros(n,m);
freq_range = 10;                       % define the frequency range in Hz

% Fill matrix with the average PSD at every of the target frequencies every
% 10ms
for i = 1:n 
    freq = freq_values(i);
    for j = 1:size(amplitudes,2) %iterating through the columns of amplitudes
        freq_idx = (f >= (freq-freq_range)) & (f <= (freq+freq_range));
        A(i,j) = mean(amplitudes(freq_idx,j));
    end
end

% Run linear regression in every column (every 10ms window)
coefs = zeros(1,m);
for j = 1:m
    lm = fitlm(freq_values, A(:,j));
    coefs(j) = lm.Coefficients.Estimate(2);
end

% Plot spectral tilt throughout the signal
x = (1:m)*0.01; % create array of time values for every 10ms window
plot(x,coefs);
xlabel('Time (s)');
ylabel('Spectral tilt');
