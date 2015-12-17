function winEnergy = windowEnergy(logEnergy, msPerWindow)

% inputs:
%   logenergy: logenergy over every 10 millisecond frame, i.e., centered at 5ms, 15ms etc. 
%   msPerWindow: duration of window to compute energy over
% output:
%   energy over windows of the designated size, centered at 10ms, 20ms, etc.
%   (the centering is off, at 15ms, 25ms, etc, if msPerWindow is 30ms, 50ms etc)
%   but we're not doing syllable-level prosody, so it doesn't matter.
%  Values returned are zero if either end of the window would go outside  
%   what we have data for. 

% Nigel Ward, UTEP, December 2014, Feb 2015

integralImage = [0 cumsum(logEnergy)];
framesPerWindow = msPerWindow / 10;
windowSum = integralImage(1+framesPerWindow:end) - integralImage(1:end-framesPerWindow);

% find silence and speech mean of track using k-means
% then use them to normalize for robustness against recording volume
[silence_mean,speech_mean] = findClusterMeans(windowSum);
scaledSum =  (windowSum - silence_mean)/(speech_mean-silence_mean);

% align so first value is for window centered at 10 ms (or 15ms if, an odd number of frames)
% using zeros for padding is really not right
headFramesToPad = floor(framesPerWindow / 2) - 1  ;
tailFramesToPad = ceil(framesPerWindow / 2) - 1  ;
winEnergy = horzcat(zeros(1,headFramesToPad),scaledSum,zeros(1,tailFramesToPad));

% test cases:
% windowEnergy([0 1 1 1 2 3 3 3 1 1 1 2], 20])
% windowEnergy([0 1 1 1 2 3 3 3 1 1 1 2], 30])

% [r,s] = readtrack('../minitest/short.au', 'l');
% e = computeLogEnergy(s(:,1)', 80, 80)
% w = windowEnergy(e, 20);
% plot(20 * (1:length(w)), w, 'g')
% hold
% w = windowEnergy(e, 50);
% plot(20 * (1:length(w)), w, 'k')
%save logEnergy;
