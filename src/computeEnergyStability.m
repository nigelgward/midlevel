function [range] = computeEnergyStability(energy, windowSize )
% Calculates evidence for different types of pitch ranges
% i.e. f = flat   (within .99-1.0 difference)
%      n = narrow (within .98-1.02 difference)
%      w = wide   (within .70-.90 difference)
%
% The evidence is the number of pitch  neighbors which are in the desired
%  relation to the centerpoint of the window.
% RelevantSpan is 1000 because being flat for more 1 second is probably rare,
%  and increasing this value slows computation
% This feature peeks beyond the window boundaries, hence is inappropriate
%  for online prediction

% Nigel Ward and Paola Gallardo, UTEP, February 2015

rangeCount = [];
msPerWindow = 10;
framesPerWindow = windowSize/msPerWindow;
relevantSpan = 200;  %temporary
framesPerHalfSpan = (relevantSpan / 2) / framesPerWindow;

for i=1:length(energy)
    %%get offset of 500 ms
    startNeighbors = i - framesPerHalfSpan;
    endNeighbors = i + framesPerHalfSpan;
    %%control out of bounds
    if(startNeighbors < 1)
        startNeighbors = 1;
    end
    if(endNeighbors > length(energy))
        endNeighbors = length(energy);
    end
    
    %%set of neighbors with pitch point in center
    neighbors = energy(startNeighbors:endNeighbors);
    %%obtain evidence
    ratios = neighbors/energy(i);
    %%based on ratio difference to center, count points with evidence
    %%for specified pitch range
    rangeCount(i) = sum(ratios>.90 & ratios<1.10);  
end




%%same old trick of integral image
integralImage = [0 cumsum(rangeCount)];
windowValues = integralImage(1+framesPerWindow:end) - integralImage(1:end-framesPerWindow);

paddingNeeded = framesPerWindow - 1;
frontPadding = zeros(1, floor(paddingNeeded / 2));
tailPadding = zeros(1, ceil(paddingNeeded / 2));
range = horzcat(frontPadding, windowValues, tailPadding);

range = range / framesPerWindow;


%%test cases
%%[y, fs, h] = readau('/home/users/nigel/21d.au');
%%[pitchPoints, b] = fxrapt(y(:,1), 8000);

%% [range] = calculatePitchRange2(pitchPoints,100,'w')
end

