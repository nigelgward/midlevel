function logEnergy = computeLogEnergy(signal, samplesPerWindow)

% Returns a vector of the energy in each frame.
% A frame is, usually, 10 milliseconds worth of samples.
% Frames do not overlap.
% Thus the values returned in logEnergy are the energy in the frames
% centered at 5ms, 15ms, 25 ms ...
 
% A typical call will be:   en = computeLogEnergy(signal, 80);

% Note that using the integral image risks overflow, so we convert to double.
% For a 10minute file, at 8K rate, there are only 5 million samples,
%  and max absolute sample value is about 20,000, and we square them,
%  so the cumsum should always be under 10 to the 17th, so should be safe.

% Nigel Ward, UTEP, November 2014

squaredSignal = signal .* double(signal);
integralImage = [0 cumsum(squaredSignal)];
integralImageByFrame = integralImage(1 : samplesPerWindow : end);
perFrameEnergy = integralImageByFrame(2:end) - integralImageByFrame(1:end-1);
perFrameEnergy = sqrt(perFrameEnergy);

% replace zeros with a small positive value (namely 1) to prevent log(0)
zeroIndices = find(perFrameEnergy==0);
perFrameEnergy(zeroIndices) = ones(1,length(zeroIndices));

logEnergy = log(perFrameEnergy);
% test cases:
%   computeLogEnergy([1 2 3 1 2 3 4 5 6], 2)
%   computeLogEnergy([1 2 3 4 5 6 5 4 3], 2)
%   computeLogEnergy([1 2 3 4 5 6 5 4 3], 3)

%   [r,s] = readtracks('../../21d.au');
%   e = computeLogEnergy(s(:,1)', 80);
%   plot(1:length(e), e, (1:length(s))/80, s(:,1)/2000)
