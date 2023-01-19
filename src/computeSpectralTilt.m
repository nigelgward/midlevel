% Carlos A. Ortega, The University of Texas at El Paso
% 01/17/2023

function tilts = computeSpectralTilt(signal, samplesPerSecond)
    % Write a csv with spectral tilt throughout the signal every ms
    
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
    window_size = round(0.025 * samplesPerSecond);   % 25ms windows
    overlap = round(0.015*samplesPerSecond);         % since we want a 10ms stride
    [S,f,t] = spectrogram(signal, window_size, overlap, freq_values, samplesPerSecond);
    
    % Build empty matrix for the amplitude values squaring the values
    % obtained from calling spectrogram
    signal_length = length(signal)/samplesPerSecond;
    nframes = round(signal_length/0.01);   % number of 10ms windows (frames)
    nfrequencies = length(freq_values);  
    amplitudes = abs(S).^2;                % calculate Power Spectral Density (PSD)
    A = zeros(nfrequencies,nframes);
    freq_range = 10;                       % define the frequency range in Hz
    
    % Fill matrix with the average PSD at each target frequencies every 10ms
    for i = 1:nfrequencies
        freq = freq_values(i);
        for j = 1:size(amplitudes,2) % iterating through the columns of amplitudes
	  %% defensive programming; actually expect just one freq_index
          freq_idx = (f >= (freq-freq_range)) & (f <= (freq+freq_range)); 
          A(i,j) = mean(amplitudes(freq_idx,j));
        end
    end
    
    fprintf("Calculating spectral tilt every 10ms...\n")
    % Run linear regression in every column (every 10ms window)
    tilts = zeros(1,nframes);
    for frame = 1:nframes
        lm = fitlm(freq_values, A(:,frame));
        tilts(frame) = lm.Coefficients.Estimate(2);
    end
    
    %% Plot spectral tilt acrossa the signal
    figure(3);
    x = (1:nframes)*0.01; % create array of time values for every 10ms window
    plot(x,tilts);
    xlabel('Time (s)');
    ylabel('Spectral tilt');
   
%%   % Write the vector containing spectral tilt every 10ms to a csv.
%%   writematrix(coefs.', outputPath)
end

%% This function recreates the method of Youyi Lu and Martin Cooke, 2009
%%  (which may not be the best method: see Sofoklis Kakouros et al, 2018)

%% Testing 1: running on a recording of a sentence, looking at the spectrogram,
%%   hand-estimating at a few points whether the tilt looks flattish or steep,
%%   and comparing to the output of this function.
%% Testing 2:
%%    running on a larger clip, 21d ...
%% Observing points of steep spectral tilt in 21d, seems to co-occur with
%%   new topic / new tack.
%% Places where she's not speaking the spectral tilt reading is usually 0.
%% Places where it spikes positive are hard to understand;
%%   single-point anomalies. 
%% Places where it's mildly negative may be topic continuation.

%% Testing 3:
%%    correlations
%% Testing 4:
%%    patterns
