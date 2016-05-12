function [ scaledLiveliness ] = computeRate(logEnergy, windowSizeMs)

% Nigel Ward and Paola Gallardo 12/04/2014

% Computes a speaking-rate proxy using a proxy for spectral flux
frames = windowSizeMs / 10;


deltas = abs(logEnergy(2:end)-logEnergy(1:end-1));   % the inter-frame deltas
cumSumDeltas = [0 cumsum(deltas)];
WindowLiveliness = cumSumDeltas(frames:end)-cumSumDeltas(1:end-frames+1);

% normalize rate for robustness against recording volume
[silence_mean, speech_mean] = findClusterMeans(logEnergy);  % k-means algorithm
scaledLiveliness = (WindowLiveliness - silence_mean)/(speech_mean-silence_mean);

headFramesToPad = floor(frames / 2) - 1;
tailFramesToPad = ceil(frames / 2) - 1;
scaledLiveliness = horzcat(zeros(1,headFramesToPad), ...
			   scaledLiveliness,         ...
			   zeros(1,tailFramesToPad));
end

% We tested this by applying it to 21d.au and listening to places
%  where the high rate values were.   
% These were in fact places where the speaker was talking quickly.
% "Ums" were detected as slow, nicely.
% Regions of silence were low on this measure, as expected.

