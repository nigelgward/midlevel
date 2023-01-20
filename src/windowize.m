function windowValues = windowize(frameFeatures, msPerWindow)

% inputs:
%   frameFeatures: features over every 10 millisecond frame,
%     centered at 5ms, 15ms etc. 
%     A row vector.
%   msPerWindow: duration of window over which to compute windowed values
% output:
%   summed values over windows of the designated size, 
%     centered at 10ms, 20ms, etc.
%     (the centering is off, at 15ms, etc, if msPerWindow is 30ms, 50ms etc)
%      but we're not doing syllable-level prosody, so it doesn't matter.
%   values are zero if either end of the window would go outside  
%     what we have data for.

%% There are other ways to windowize (mean, std-dev, range, etc),
%%  so this should probably be called windowizeSum 

% Nigel Ward, UTEP, Feb 2015

integralImage = [0 cumsum(frameFeatures)];
framesPerWindow = msPerWindow / 10;
windowSum = integralImage(1+framesPerWindow:end) - ...
	    integralImage(1:end-framesPerWindow);

% align so first value is for window centered at 10 ms 
%  (or 15ms if, an odd number of frames)
headFramesToPad = floor(framesPerWindow / 2) - 1  ;
tailFramesToPad = ceil(framesPerWindow / 2) - 1  ;
tailFramesToPad = ceil(framesPerWindow / 2);
windowValues = horzcat(zeros(1,headFramesToPad), ...
		       windowSum, ...
		       zeros(1,tailFramesToPad));

% test cases:
% windowize([0 1 1 1 2 3 3 3 1 1 1 2], 20])
% windowize([0 1 1 1 2 3 3 3 1 1 1 2], 30])

