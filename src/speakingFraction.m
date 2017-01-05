function vec = speakingFraction(logEnergy, msPerWindow)

% returns the fraction of time in th each window with speech 
% This could use a proper VAD, but they have a lot of assumptions.
% This will correlate highly with the vo (windowEnergy) feature,
%  except it will be affected less by speech that's quiet or loud

% derived from windowEnergy.m.  See that file for description of inputs 

% Nigel Ward, UTEP, December 2014, Feb 2015

% find silence and speech mean of track using k-means
[silence_mean,speech_mean] = findClusterMeans(logEnergy);

% Set the speech/ilence threshold closer to the silence mean
%   because the variance  of silence is less than that of speech
% This is ad hoc; modeling with two gaussians would probably be better
threshold = (2 * silence_mean + speech_mean) / 3.0;

speakingFrames = logEnergy > threshold;
vec = windowize(speakingFrames, msPerWindow);

% test cases:
% speakingFraction([0 0 0 0 5 5 5 5 4 4 4 4 0 0 0 1 1 1 1 1 0 0  0 0 0 0 0 3 3 3 3 5 5 1 0 0 0 ], 20)


%[r,s] = readtracks('../flowtest/21d.au');
% e = computeLogEnergy(s(:,1)', 80);
% sf = speakingFraction(e, 200);
% plot(sf * 0.1, 'g')
% we = windowEnergy(e, 200);
% hold
% plot(we, 'b')
% compare to audio


