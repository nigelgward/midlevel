function [range] = computePitchRange(pitch, windowSize,rangeType )
% Calculates evidence for different types of pitch ranges
%i.e. f = flat   (within .99-1.0 difference)
%     n = narrow (within .98-1.02 difference)
%     w = wide   (within .70-.90 difference)
%
% evidence calculation: set of neigbors/current pitch point
% normalized by the expected evidence, which is proportional to square of window size

% Nigel Ward and Paola Gallardo, UTEP, February 2015

rangeCount = [];
framesPerWindow = windowSize/10;

for i=1:length(pitch)
    %%get offset of 500 ms
    startNeighbors = i-50;
    endNeighbors = i+50;
    %%control out of bounds
    if(startNeighbors < 1)
        startNeighbors = 1;
    end
    if(endNeighbors > length(pitch))
        endNeighbors = length(pitch);
    end
    
    %%set of neighbors with pitch point in center
    neighbors = pitch(startNeighbors:endNeighbors);
    %%obtain evidence
    ratios = neighbors/pitch(i);
    %%based on ratio difference to center, count points with evidence
    %%for specified pitch range
    switch rangeType
        case 'f'
             %does not seem to be usefully different from narrow
            rangeCount(i) = sum( ratios>=.99 & ratios <=1.01 );       
        case 'n'
            rangeCount(i) = sum((ratios>.98 & ratios<1.02));  
        case 'w'
            %if difference is <.70 or >1.3, most likely spurious pitch
            %point
            rangeCount(i) = sum((ratios>.70 & ratios<.90)  |  (ratios >1.1 & ratios<1.3));
    end
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

