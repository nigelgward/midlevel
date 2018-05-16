function vals = computeFeature()
   % a driver for makeTrackMonster.m, used for small-scale testing, 
   % Nigel Ward, May 2017, UTEP

  file = '1110Kbnd8pmFireUpdateRoosterRockFire.au';
  file = 'SpaceCoastRadioNEWS07152013.au';
  dir = 'h:/nigel/stance/english/audio/';
  file = 'ben04.au';
  dir = 'h:/nigel/comparisons/bn-lorelei/';
  file = 'habu-ken.au';
  dir = 'h:/nigel/comparisons/jp-chat-tokyo/concatenated/'
%%  file = 'spa10.au';
  %%  dir = 'h:/nigel/comparisons/es-lorelei/';
%  dir = 'h:/nigel/lorelei/ldc-from/englishE50/USE_EVAL_20170906/USE_EVAL_20170906/en-lorelei';

  
  trackspec = makeTrackspec('l', file, dir);
%    featureList(1) = makeFeatureSpec('le', -800, -400, 'self', 0);
%    featureList(1) = makeFeatureSpec('vr', -800, -400, 'self', 0);
%    trackspec = makeTrackspec('l', 'utep21.au', 'h:/nigel/comparisons/en-social/');
    featureList(1) = makeFeatureSpec('cr', -100, +100, 'self', 0);
    featureList(2) = makeFeatureSpec('cr', -500, +500, 'self', 0);
    featureList(3) = makeFeatureSpec('pd', -50, +50, 'self', 0); % peak disalignment
%    featureList(3) = makeFeatureSpec('cr', -100, +100, 'inte', 0);
%    featureList(4) = makeFeatureSpec('cr', -500, +500, 'inte', 0);


    [~, vecset] = makeTrackMonster(trackspec, featureList);
    % vals = vecset(:,1);
%%    writeExtremesToFile('highlyCreaky200.txt', vecset(:,1), vecset(:,1), ...
%%			'times of 200ms high creak', 'en-social/utep21.au left');
%%    writeExtremesToFile('highlyCreaky1000.txt', vecset(:,2), vecset(:,2), ...
%%			'times of 1s high creak', 'en-social/utep21.au left');
%%    writeExtremesToFile('highlyCreaky200.txt', vecset(:,3), vecset(:,3), ...
%%			'times of 200ms high creak', 'en-social/utep21.au right');
%%    writeExtremesToFile('highlyCreaky1000.txt', vecset(:,4), vecset(:,4), ...
%%			'times of 1s high creak', 'en-social/utep21.au right');
    outfile = sprintf('pd100-%s.txt', file);
    writeExtremesToFile(outfile, vecset(:,3), vecset(:,3), ...
			'times of high disalignment', file);
    
end
