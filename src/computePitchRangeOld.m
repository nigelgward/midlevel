function [range] = computePitchRange(pitch, timePoints, windowSize,rangeType )
% Calculates evidence for different types of pitch ranges
%i.e. f = flat   (within 2% difference)
%     n = narrow (within 2-8% difference)
%     t = typical (within 8-20% difference)
%     w = wide   (within 50-90% difference)
%
% evidence calculation: square root of sum of point-pairs that support
%                the hypothesis that this is the pitch range,
% normalized by the expected evidence, which is proportional to square of window size

% Paola Gallardo, UTEP, December 2014

maxpitch = 500; 
totalTimePointsWithNaN = size(timePoints,1);

indicesWithoutNaN = find(pitch <= maxpitch);
time = timePoints(indicesWithoutNaN);
pitch = pitch(indicesWithoutNaN);

totalTimePoints = size(time,1);
timeOfLastValidPitchPoint = time(totalTimePoints);
%%number of times the window (calculation) will be applied
msPerFrame = 10;

%%set up output
range = zeros(totalTimePointsWithNaN,1);

%%counter to find current time point (every 10 ms)
windowCenter = 1;

for i=1:totalTimePoints
        %%get the entire window
        startPoint = windowCenter-round(windowSize/2);
        endPoint = windowCenter+round(windowSize/2);
        %%avoid out of bounds accessing
        if(startPoint < 1)
            startPoint = 1;
        end
        if(endPoint > timeOfLastValidPitchPoint)
            endPoint = timeOfLastValidPitchPoint;
        end
        %%finds all the pitch points in the given window
        allPointsInWindow = pitch(find(time>=startPoint & time<=endPoint));
        indExist = isempty(allPointsInWindow);
          %if pitch points exist in the window
          if(indExist~=1)
             %set up number of comparisons
             pointsToCompare = size(allPointsInWindow,1)-1;
             comparisonSize = (pointsToCompare*(pointsToCompare+1))/2;
             %get percentage difference of pairs of points,otherwise stays
             %0
             percentDifferenceVector = zeros(1,comparisonSize);
             sizeofAllPointsInWindow = length(allPointsInWindow);
             currentPointOfVector = 1;
             for curr=1:sizeofAllPointsInWindow-1
                 currentDifference = abs(allPointsInWindow(curr)-allPointsInWindow(curr+1:end))./((allPointsInWindow(curr)+allPointsInWindow(curr+1:end))/2);
                 sizeOfCurrentDifference = length(currentDifference);
                 percentDifferenceVector(currentPointOfVector:currentPointOfVector+sizeOfCurrentDifference-1) = currentDifference;
                 currentPointOfVector = currentPointOfVector+sizeOfCurrentDifference;
             end
            % percentDifferenceVector = getDifferenceVector(allPointsInWindow,comparisonSize);
             %evidence added to respective arrays
             switch rangeType
                 case 'f'
                    range(i)=(sqrt(sum(percentDifferenceVector(find(percentDifferenceVector<=.01)))))/(windowSize*windowSize);
                 case 'n'
                    range(i)=(sqrt(sum(percentDifferenceVector(find(percentDifferenceVector>.01 & percentDifferenceVector<=.02)))))/(windowSize*windowSize);
                 case 't'
                    range(i)=(sqrt(sum(percentDifferenceVector(find(percentDifferenceVector>.02 & percentDifferenceVector<=.1)))))/(windowSize*windowSize);
                 case 'w'
                    range(i)=(sqrt(sum(percentDifferenceVector(find(percentDifferenceVector>.1 & percentDifferenceVector<=.3)))))/(windowSize*windowSize);
             end
          end
          %%next time point
    windowCenter = windowCenter+msPerFrame;
end

filterPoints = find(range(:)~=0);
filterTimePoints = filterPoints*10;

%figure
%scatter(time(1:end), pitch(1:end))
%hold on
%scatter(filterTimePoints,(flat(filterPoints)*1000000));
%hold off
%
%filterPoints = find(narrow(:)~=0);
%filterTimePoints = filterPoints*10;
%figure
%scatter(time(1:end), pitch(1:end))
%hold on
%scatter(filterTimePoints,(narrow(filterPoints)*1000000));
%hold off
%
%filterPoints = find(normal(:)~=0);
%filterTimePoints = filterPoints*10;
%figure
%scatter(time(1:end), pitch(1:end))
%hold on
%scatter(filterTimePoints,(normal(filterPoints)*1000000));
%hold off
%
%filterPoints = find(wide(:)~=0);
%filterTimePoints = filterPoints*10;
%figure
%scatter(time(1:end), pitch(1:end))
%hold on
%scatter(filterTimePoints,(wide(filterPoints)*1000000));
%hold off





%%test cases
%%[y, fs, h] = readau('/home/users/nigel/21d.au');
%%[pitchPoints, b] = fxrapt(y(:,1), 8000);

%% [range] = calculate_pitch_range(pitchPoints,b,8000,100,'f')
end

