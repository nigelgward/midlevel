% ppeakness.m     Pitch Peakness
% Nigel Ward, University of Texas at El Paso and Kyoto University
% January 2016

% Given a vector of pitch-vs-time
% return another vector of the same size.  The value at each point 
% represents the likelihood/strength of a peak there
%
% Pitch peaks have to meet three criteria: 
%  1. the pitch is high, globally
%  2. it's higher than anywhere else in this syllable
%  3. there are enough nearby pitch points for it to be reliable/salient

% Pitch may have NaNs.  In general these are tricky, but here we just set
%  them all to zero.   Zero times anything is zero, so this means 
%  that effectively the convolution will be done skipping over those points
%
% Regarding syllable length, see comment in epeakness.m 

% the input is pitch percentiles, and thus ranges from 0 to 1

function peakness = ppeakness(pitchPtile)
  ssFW = 10;    % stressed-syllable filter width; could be 12

  validPitch = pitchPtile > 0;
  localPitchAmount = myconv(1.0 * validPitch, triangleFilter(160), 10);

  pitchPtile(isnan(pitchPtile)) = 0;
  localPeakness = myconv(pitchPtile, laplacianOfGaussian(ssFW), 2.5 * ssFW);

  peakness = localPeakness .* localPitchAmount .* pitchPtile;
  peakness(peakness<0) = 0;      % don't care about troughs

end

% validation: looking at the plots, there are lots of upside down U shapes
% and when I listen to them, I hear a clearly high pitch, more clearly
% to the extent the bumps are taller (and/or fatter?)
