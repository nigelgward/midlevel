function [cleanPitchl, cleanPitchr] = killBleeding(pitchl, pitchr, energyl, energyr)
  
% Nigel Ward, UTEP, 2015
% if the pitch is the same in both tracks, 
%  and one track is clearly louder than the other,
% assume bleeding, and set the pitch value in the quieter track value to NaN

% threshold: the min difference in log-energy values between tracks
%  to say there's speech in one but not in the other
% This was by looking at 21d.au and trying different thresholds
% In general, this will depend on microphone placements etc.
clearDifference = 0.8;    

  % the energy features are centered at 5ms, 15ms, 25ms etc
  % the pitch features are center at 10ms, 20ms, 30ms etc. 
  leftTwentyMsEnergy  = energyl(1:end-1) + energyl(2:end);
  rightTwentyMsEnergy = energyr(1:end-1) + energyr(2:end);

  leftLouder = leftTwentyMsEnergy > rightTwentyMsEnergy + clearDifference;
  rightLouder = rightTwentyMsEnergy > leftTwentyMsEnergy + clearDifference;
  pitchesSame = pitchl./pitchr > .95 & pitchl./pitchr < 1.05;
  pitchesDoubled = pitchl./pitchr > .475 & pitchl./pitchr < .525;
  pitchesHalved = pitchl./pitchr > 1.90 & pitchl./pitchr < 2.10;
  pitchesSuspect = pitchesSame | pitchesDoubled | pitchesHalved;

  % note: crashes at this point are often due to stale pitchCache files
  bleedingToLeft = rightLouder' & pitchesSuspect;
  bleedingToRight = leftLouder' & pitchesSuspect;
  cleanPitchl = pitchl;
  cleanPitchl(bleedingToLeft) = NaN;
  cleanPitchr = pitchr;
  cleanPitchr(bleedingToRight) = NaN;
end

% test data, assuming left speaker is male, right speaker is female,
% and there's bleeding both ways
% and there are randomly NaNs and garbage pitch-points
% rawl    = [ 85 NaN  90  80  85  30 400 200 200 200 199 NaN]
% energyl = [  5   5   5   5   5   1   1   1   1   1   1   1  1]
% rawr =    [NaN NaN  90  80  85 400 300 199 201 201 199 199]
% energyr = [  1   1   1   1   1   1   1   5   5   5   5   5  5]
% killBleeding(rawl, rawr, energyl, energyr)
