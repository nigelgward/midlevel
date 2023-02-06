function vals = computeFeature()
%% a driver for makeTrackMonster.m, used for small-scale testing, 
%% Nigel Ward, May 2017, UTEP

  file = 'habu-ken.au';
  dir = 'h:/nigel/comparisons/jp-chat-tokyo/concatenated/';

  dir = 'c:/nigel/midlevel/flowtest/';
  file = '21d.wav';
  dir = 'c:/nigel/comparisons-partial/en-social/';
  file = 'utep04-first5min.wav';
  %%file = 'sw02008.wav';
  side = 'r';

  trackspec = makeTrackspec(side, file, dir);
  %% featureList(1) = makeFeatureSpec('le', -800, -400, 'self', 0);
  %%featureList(1) = makeFeatureSpec('cr', -100, +100, 'self', 0);
  %featureList(2) = makeFeatureSpec('cr', -500, +500, 'self', 0);
  %featureList(3) = makeFeatureSpec('pd', -100, +100, 'self', 0);
  featureList(1) = makeFeatureSpec('tr', -200, +200, 'self', 0);
  featureList(2) = makeFeatureSpec('tf', -200, +200, 'self', 0);
  featureList(3) = makeFeatureSpec('tm', -200, +200, 'self', 0);
  featureList(4) = makeFeatureSpec('tn', -200, +200, 'self', 0); 

  [~, vecset] = makeTrackMonster(trackspec, featureList);
  infostring = sprintf('%s %s %s', dir, file, side);
  writeExtremesToFile('tiltRange400.txt', vecset(:,1), vecset(:,1), ...
		      'tiltRange', infostring);
  writeExtremesToFile('flatTilt400.txt', vecset(:,2), vecset(:,2), ...
		      'flatTilt', infostring);
  writeExtremesToFile('middlingTilt400.txt', vecset(:,3), vecset(:,3), ...
		      'midlingTilt', infostring);
  writeExtremesToFile('negTilt400.txt', vecset(:,4), vecset(:,4), ...
		      'negTilt', infostring);
end

