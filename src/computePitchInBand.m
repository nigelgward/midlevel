function bandValues = computePitchInBand(percentiles, bandFlag, windowSizeMs)
% compute evidence for the pitch being strongly in the specified band
%  bandflag 'l' is low pitch; 'h' is high pitch
%   'tl' and 'th' are "truly high" and "truly low", more strictly
%  in future, may have a mid-range band, etc. 
% both percentiles and bandValues are column vectors

% Nigel Ward February 2015

% despite the name, percentiles is a vector of values from 0 to 1
% with some NaNs mixed in.  As produced by percentalizePitch.m

switch(bandFlag)
case 'h'
  % for computing evidence for high pitch, NaNs contribute nothing, same as 0s
  percentiles(isnan(percentiles)) = 0.00;
  evidenceVector = percentiles;
case 'l'
  % for computing evidence for low pitch, NaNs contribute nothing, same as 1s
  percentiles(isnan(percentiles)) = 1.00;
  evidenceVector = 1 - percentiles;  % the lower the pitch value, the more evidence
case 'th'   
  % 50th percentile counts a tiny bit "truly-high", below 50th percentile, not at all
  percentiles(isnan(percentiles)) = 0.00;
  percentiles(percentiles < 0.50) = 0.50;
  evidenceVector = percentiles - 0.50;
case 'tl'   
  % 49th percentile counts a tiny bit "truly-low", above 50th percentile, not at all
  percentiles(isnan(percentiles)) = 1.00;
  percentiles(percentiles > 0.50) = 0.50;
  evidenceVector = 0.50 - percentiles;
otherwise
  disp(' sorrry, unknown flag' + bandFlag);  
end 

integralImage = vertcat( [0], cumsum(evidenceVector));
framesPerWindow = windowSizeMs / 10;
windowValues = integralImage(1+framesPerWindow:end) - ...
               integralImage(1:end-framesPerWindow);

% add more padding to the front.
% if framesPerWindow is even, this means the first value will be at 15ms
% otherwise it will be at 10ms 
paddingNeeded = framesPerWindow - 1;
frontPadding = zeros(floor(paddingNeeded / 2),1);
tailPadding = zeros(ceil(paddingNeeded / 2),1);
bandValues = vertcat(frontPadding, windowValues, tailPadding);

% now normalize, just so that when we plot them, the ones with longer windows are
% not hugely higher than the rest
bandValues = bandValues / framesPerWindow;

% pitchHighness test cases
% computePitchInBand([ 0 0 0 0 NaN 0 0 0 0 0 0 0.01],   'h', 90) % near zero
% computePitchInBand([ 1 1 1 .9 NaN .8 Nan Nan Nan Nan],'h', 90) % near one
% computePitchInBand([ 1 1 1 .9 NaN .8 .6 .5 .4 .6 ],   'h', 90) % nearer one
% computePitchInBand([ 1 1 1 .9 NaN .8 .9 1.0 .95 .95 ],'h', 90) % even nearer one

% pitchLowness test cases
% computePitchInBand([ 0 0 0 0 NaN 0 0 0 0 0 0 0.01],'l', 90)     % near one
% computePitchInBand([ 1 1 1 .9 NaN .8 .9 1.0 .95 .95 ],'l', 90)  % very near zero
% computePitchInBand([ 1 1 1 .9 NaN .8 Nan Nan Nan Nan ],'l', 90) % about the same
% computePitchInBand([ .5 .5 .5 .9 NaN .2 .6 .5 .4 .6 ],'l', 90)  % near .5
% computePitchInBand([ .5 .5 .5 .8 NaN .2 .6 .5 .4 .5 ],'l', 90)   % a little higher



