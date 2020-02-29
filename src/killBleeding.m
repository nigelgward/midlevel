function [cleanPitchl, cleanPitchr, npoints] = killBleeding(pitchl, pitchr, energyl, energyr)
  
  %% Nigel Ward, UTEP, 2015 if the pitch is the same in both tracks,
  %% and one track is clearly louder than the other, then assume
  %% bleeding, and set the pitch value in the quieter track value to  NaN

  %% clearDifference is the threshold, that is, the min difference in
  %% log-energy values between tracks to say there's speech in one but
  %% not in the other.  This was set by trying different thresholds for
  %% 21d.au. In general, this will depend on microphone placements etc.
  clearDifference = 0.8;
  
  %% the pitch features are centered at 10ms, 20ms, 30ms etc. 
  %% the energy features are centered at 5ms, 15ms, 25ms, so adjust 
  energylShifted  = energyl(1:end-1) + energyl(2:end);
  energyrShifted = energyr(1:end-1) + energyr(2:end);

  %% fprintf('size of energylShifted is %d %d\n', size(energylShifted));
  %% fprintf('size of energyrShifted is %d %d\n', size(energyrShifted));
  %% fprintf('size of pitchl is %d %d\n', size(pitchl));
  %% fprintf('size of pitchr is %d %d\n', size(pitchr));

  %% needed since it seems that reaper pitch output can be randomly one more or less
  nPitchPoints = min([size(pitchl,1), size(pitchr,1), length(energylShifted), length(energyrShifted)]);
  pitchl = pitchl(1:nPitchPoints);
  pitchr = pitchr(1:nPitchPoints);
  energylShifted = energylShifted(1:nPitchPoints);
  energyrShifted = energyrShifted(1:nPitchPoints);

  leftLouder = energylShifted > energyrShifted + clearDifference;
  rightLouder = energyrShifted > energylShifted + clearDifference;
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

  npoints = nPitchPoints;
end

% test data, assuming left speaker is male, right speaker is female,
% and there's bleeding both ways
% and there are randomly NaNs and garbage pitch-points
% rawl    = [ 85 NaN  90  80  85  30 400 200 200 200 199 NaN]
% energyl = [  5   5   5   5   5   1   1   1   1   1   1   1  1]
% rawr =    [NaN NaN  90  80  85 400 300 199 201 201 199 199]
% energyr = [  1   1   1   1   1   1   1   5   5   5   5   5  5]
% killBleeding(rawl, rawr, energyl, energyr)
